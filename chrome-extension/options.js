const DEFAULT_BASE_URL = 'https://soal.help/api/v1';
const MODELS_URL = 'https://soal.help/api/models';

const $ = (id) => document.getElementById(id);
const status = $('status');

function setStatus(text, kind = 'info') {
  status.textContent = text;
  status.dataset.kind = kind;
  if (text) setTimeout(() => (status.textContent = ''), 3000);
}

async function loadModels(selected) {
  const select = $('defaultModel');
  select.innerHTML = '<option>...جارٍ التحميل</option>';
  try {
    const r = await fetch(MODELS_URL);
    const data = await r.json();
    const list = (data.models || data || []).filter((m) => m.category === 'chat' && (m.is_active ?? true));
    if (list.length === 0) throw new Error('no chat models');
    select.innerHTML = list
      .map(
        (m) =>
          `<option value="${m.model_id}"${
            selected === m.model_id ? ' selected' : ''
          }>${m.label || m.name || m.model_id}</option>`,
      )
      .join('');
  } catch (e) {
    select.innerHTML = `<option value="claude-haiku-4-5-20251001">Claude Haiku 4.5 (fallback)</option>`;
    console.warn('failed to load models', e);
  }
}

async function init() {
  const cfg = await chrome.storage.local.get(['apiKey', 'baseUrl', 'defaultModel']);
  $('apiKey').value = cfg.apiKey || '';
  $('baseUrl').value = cfg.baseUrl || DEFAULT_BASE_URL;
  await loadModels(cfg.defaultModel);
}

$('save').addEventListener('click', async () => {
  const apiKey = $('apiKey').value.trim();
  const baseUrl = $('baseUrl').value.trim() || DEFAULT_BASE_URL;
  const defaultModel = $('defaultModel').value;
  if (!apiKey.startsWith('sk-')) {
    setStatus('مفتاح API لازم يبدأ بـ sk-', 'error');
    return;
  }
  await chrome.storage.local.set({ apiKey, baseUrl, defaultModel });
  setStatus('اتحفظ ✔', 'ok');
});

init();
