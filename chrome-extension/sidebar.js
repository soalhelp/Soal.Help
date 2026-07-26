// Sidebar chat controller for Soal.help.
// - Reads config (apiKey / baseUrl / defaultModel) from chrome.storage.local.
// - Loads model list from https://soal.help/api/models (no auth needed).
// - Streams responses via SSE and updates the assistant bubble live.
// - After each response, pulls x_billing.balance_after_egp from the final
//   chunk's usage payload (soal.help injects it in the streaming choices).

const DEFAULT_BASE_URL = 'https://soal.help/api/v1';
const MODELS_URL = 'https://soal.help/api/models';

const els = {
  messages: document.getElementById('messages'),
  empty: document.getElementById('emptyState'),
  input: document.getElementById('promptInput'),
  send: document.getElementById('sendBtn'),
  clear: document.getElementById('clearBtn'),
  settings: document.getElementById('settingsBtn'),
  model: document.getElementById('modelSelect'),
  status: document.getElementById('statusBar'),
  balance: document.getElementById('lastBalance'),
};

let history = [];
let controller = null;

function scrollToBottom() {
  els.messages.scrollTop = els.messages.scrollHeight;
}

function bubble(role, text = '') {
  const div = document.createElement('div');
  div.className = `msg ${role}`;
  div.textContent = text;
  els.messages.appendChild(div);
  scrollToBottom();
  return div;
}

function appendCopy(bubbleEl) {
  const btn = document.createElement('button');
  btn.className = 'copy-btn';
  btn.textContent = 'نسخ الرد';
  btn.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(bubbleEl.dataset.raw || bubbleEl.textContent);
      btn.textContent = 'اتنسخ ✔';
      setTimeout(() => (btn.textContent = 'نسخ الرد'), 1500);
    } catch (e) {
      btn.textContent = 'فشل النسخ';
    }
  });
  bubbleEl.appendChild(btn);
}

function setStatus(text) {
  els.status.textContent = text || '';
}

function typingIndicator() {
  const el = document.createElement('div');
  el.className = 'msg assistant';
  el.innerHTML =
    '<span class="typing"><span class="dot"></span><span class="dot"></span><span class="dot"></span></span>';
  els.messages.appendChild(el);
  scrollToBottom();
  return el;
}

async function loadModels(selected) {
  try {
    const r = await fetch(MODELS_URL);
    const data = await r.json();
    const list = (data.models || data || []).filter(
      (m) => m.category === 'chat' && (m.is_active ?? true),
    );
    els.model.innerHTML = list
      .map(
        (m) =>
          `<option value="${m.model_id}"${
            selected === m.model_id ? ' selected' : ''
          }>${m.label || m.name || m.model_id}</option>`,
      )
      .join('');
  } catch (e) {
    els.model.innerHTML = `<option value="claude-haiku-4-5-20251001">Claude Haiku 4.5</option>`;
  }
}

async function loadConfig() {
  const cfg = await chrome.storage.local.get([
    'apiKey',
    'baseUrl',
    'defaultModel',
    'pending_prompt',
  ]);
  await loadModels(cfg.defaultModel);
  if (cfg.pending_prompt) {
    els.input.value = cfg.pending_prompt;
    await chrome.storage.local.remove('pending_prompt');
  }
  if (!cfg.apiKey) {
    setStatus('ما فيش مفتاح API — افتح الإعدادات أولاً.');
  }
  return {
    apiKey: cfg.apiKey || '',
    baseUrl: cfg.baseUrl || DEFAULT_BASE_URL,
  };
}

function fmtEgp(v) {
  if (v == null) return '—';
  return `${Number(v).toFixed(2)} ج.م`;
}

async function streamChat({ apiKey, baseUrl, messages, model, onDelta }) {
  controller = new AbortController();
  const res = await fetch(`${baseUrl.replace(/\/$/, '')}/chat/completions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify({ model, messages, stream: true }),
    signal: controller.signal,
  });

  if (!res.ok) {
    const errText = await res.text().catch(() => '');
    let msg = `HTTP ${res.status}`;
    try {
      const j = JSON.parse(errText);
      msg = j.error?.message || j.detail || msg;
    } catch {
      /* not json */
    }
    throw new Error(msg);
  }

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buf = '';
  let lastChunk = null;
  while (true) {
    const { value, done } = await reader.read();
    if (done) break;
    buf += decoder.decode(value, { stream: true });
    let idx;
    while ((idx = buf.indexOf('\n')) !== -1) {
      const line = buf.slice(0, idx).trim();
      buf = buf.slice(idx + 1);
      if (!line.startsWith('data:')) continue;
      const payload = line.slice(5).trim();
      if (!payload || payload === '[DONE]') continue;
      try {
        const chunk = JSON.parse(payload);
        lastChunk = chunk;
        const delta = chunk.choices?.[0]?.delta?.content;
        if (delta) onDelta(delta);
      } catch {
        /* ignore malformed line */
      }
    }
  }
  return lastChunk;
}

async function send() {
  const prompt = els.input.value.trim();
  if (!prompt) return;
  const { apiKey, baseUrl } = await loadConfig();
  if (!apiKey) {
    setStatus('مفتاح API مش موجود — روح للإعدادات.');
    return;
  }

  if (els.empty) els.empty.style.display = 'none';
  const userBubble = bubble('user', prompt);
  userBubble.dataset.raw = prompt;
  history.push({ role: 'user', content: prompt });
  els.input.value = '';
  els.input.style.height = 'auto';

  els.send.disabled = true;
  els.send.querySelector('.send-label').textContent = 'إيقاف';
  const typing = typingIndicator();
  let assistantEl = null;
  let acc = '';
  setStatus('جاري الرد...');

  try {
    const model = els.model.value;
    const finalChunk = await streamChat({
      apiKey,
      baseUrl,
      messages: history,
      model,
      onDelta: (d) => {
        acc += d;
        if (!assistantEl) {
          typing.remove();
          assistantEl = bubble('assistant', acc);
        } else {
          assistantEl.textContent = acc;
        }
        scrollToBottom();
      },
    });
    if (!assistantEl) {
      typing.remove();
      assistantEl = bubble('assistant', acc || '(رد فارغ)');
    }
    assistantEl.dataset.raw = acc;
    appendCopy(assistantEl);
    history.push({ role: 'assistant', content: acc });

    // Soal.help injects billing in the final chunk's `x_billing`.
    const bal = finalChunk?.x_billing?.balance_after_egp;
    const cost = finalChunk?.x_billing?.cost_egp;
    if (bal != null) els.balance.textContent = fmtEgp(bal);
    setStatus(cost != null ? `تكلفة الرد: ${Number(cost).toFixed(4)} ج.م` : '');
  } catch (e) {
    typing.remove();
    if (e.name === 'AbortError') {
      setStatus('تم إيقاف الرد.');
    } else {
      const err = bubble('error', `فشل: ${e.message}`);
      err.dataset.raw = e.message;
      setStatus('');
    }
  } finally {
    controller = null;
    els.send.disabled = false;
    els.send.querySelector('.send-label').textContent = 'إرسال';
  }
}

function abort() {
  if (controller) {
    controller.abort();
    controller = null;
  }
}

// --- Event wiring ---

els.send.addEventListener('click', () => {
  if (controller) abort();
  else send();
});

els.input.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault();
    if (!controller) send();
  }
});

els.input.addEventListener('input', () => {
  els.input.style.height = 'auto';
  els.input.style.height = Math.min(els.input.scrollHeight, 160) + 'px';
});

els.clear.addEventListener('click', () => {
  history = [];
  els.messages.innerHTML = '';
  els.messages.appendChild(els.empty);
  els.empty.style.display = '';
  setStatus('اتمسحت المحادثة.');
});

els.settings.addEventListener('click', () => chrome.runtime.openOptionsPage());

document.querySelectorAll('.chip').forEach((c) => {
  c.addEventListener('click', () => {
    els.input.value = c.dataset.prompt;
    els.input.focus();
  });
});

loadConfig();
