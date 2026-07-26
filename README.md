<div align="center">

# 🌍 Soal.help — Universal Clients

**بوابة النماذج الاصطناعية — عملاء لكل الأجهزة**

استخدم موديلات Claude · GPT · Gemini في تطبيقاتك وترمناتك — بمفتاح واحد.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Website](https://img.shields.io/badge/Website-soal.help-orange)](https://soal.help)
[![API](https://img.shields.io/badge/API-OpenAI--Compatible-blue)](https://soal.help/docs)

<img src="chrome-extension/icons/icon128.png" width="96" alt="Soal.help" />

</div>

---

<table>
<tr>
<td width="50%" valign="top">

## 🇪🇬 عربي

**Soal.help** بوابة API واحدة بتوصلك على كل موديلات الذكاء الاصطناعي — Claude,
GPT, Gemini, Sora, Nano Banana — بحساب واحد ومحفظة واحدة بالجنيه المصري.

الريبو ده فيه عملاء جاهزين لكل جهاز:

| الجهاز        | الأداة              | التثبيت |
|---------------|---------------------|---------|
| 🐧 لينكس / ماك | `aichat` (Terminal) | [linux-macos/](linux-macos/) |
| 🖥️ ويندوز    | `aichat` (PowerShell)| [windows/](windows/) |
| 📱 أندرويد   | Codex CLI (Termux)  | [termux/](termux/) |
| 🌐 كروم/إدج   | Side Panel Extension| [chrome-extension/](chrome-extension/) |
| ⌨️ VSCode/Cursor| Continue.dev       | [vscode-cursor/](vscode-cursor/) |
| 💻 مطوّرين  | curl / Python / Node| [examples/](examples/) |

</td>
<td width="50%" valign="top">

## 🇬🇧 English

**Soal.help** is a single OpenAI-compatible API gateway that gives you access
to every major AI model — Claude, GPT, Gemini, Sora, Nano Banana — through one
account and one wallet (billed in EGP).

This repo packages ready-to-use clients for every platform:

| Platform      | Client              | Install |
|---------------|---------------------|---------|
| 🐧 Linux / Mac| `aichat` (Terminal) | [linux-macos/](linux-macos/) |
| 🖥️ Windows   | `aichat` (PowerShell)| [windows/](windows/) |
| 📱 Android    | Codex CLI (Termux)  | [termux/](termux/) |
| 🌐 Chrome/Edge| Side Panel Extension| [chrome-extension/](chrome-extension/) |
| ⌨️ VSCode/Cursor| Continue.dev       | [vscode-cursor/](vscode-cursor/) |
| 💻 Developers| curl / Python / Node| [examples/](examples/) |

</td>
</tr>
</table>

---

## 🔑 الخطوة الأولى — الحصول على مفتاح API / Step 1 — Get Your API Key

1. سجّل حساب على [soal.help](https://soal.help/register) (اشحن محفظتك بأي مبلغ).
2. من لوحة التحكم → **مفاتيح API** → **إنشاء مفتاح جديد**.
3. انسخ المفتاح (شكله `sk-...`) — الخطوة دي بتحصل مرة واحدة، بعدها تقدر تستخدم نفس المفتاح مع كل الأدوات تحت.

> 💡 المفتاح ده لا يظهر مرة تانية بعد ما تقفل الصفحة — احفظه في مكان أمين.

---

## 📱 أندرويد (Termux) — Android

<details open>
<summary><b>افتح للتفاصيل / Click to expand</b></summary>

**متطلبات:**
- أندرويد 10+ (ARM64)
- تطبيق [Termux من F-Droid](https://f-droid.org/en/packages/com.termux/) — النسخة اللي على Play Store قديمة.

**التثبيت في سطر واحد** (بيسطّب Node.js + fzf + Codex CLI + إعدادات Soal.help — كلها لوحده):

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux/install.sh | bash
```

الـ Installer هيسألك:
1. اللغة (عربي/إنجليزي)
2. مفتاح API — تلصقه بس، وهو بيقرأه من أي شكل (سواء `sk-...` لوحده أو `SOAL_API_KEY="sk-..."`).

**بعد التثبيت:**
```bash
soal --list                    # يعرض 11 موديل مدعوم
soal claude-opus               # يشغّل Claude Opus مباشرة
soal gpt5 "اكتب قصة"           # يشغّل GPT-5 + prompt
soal                           # قائمة تفاعلية بـ fzf
```

**سكريبتات مساعدة:**
- 🩺 **Doctor** — يفحص كل حاجة عندك ويقول إيه شغال وإيه لأ:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux/doctor.sh | bash
  ```
- 🧹 **Reset** — يمسح كل حاجة ويرجّعك للبداية:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux/reset.sh | bash
  ```

[📖 الدليل التفصيلي](termux/)

</details>

---

## 🐧 لينكس / ماك — Linux & macOS

<details>
<summary><b>افتح للتفاصيل / Click to expand</b></summary>

**سطر واحد يسطّبلك كل حاجة** — يثبّت [aichat](https://github.com/sigoden/aichat) ويظبّطه على soal.help.

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/linux-macos/install.sh | bash
```

بعد التثبيت:
```bash
# جلسة تفاعلية
aichat

# سؤال سريع
aichat "قوللي معلومة عن الأهرامات"

# اختار موديل معيّن
aichat -m claude-opus-4-8 "اكتب قصيدة عن القاهرة"

# pipe input
cat main.py | aichat "راجع الكود ده"
```

[📖 الدليل التفصيلي](linux-macos/)

</details>

---

## 🖥️ ويندوز — Windows

<details>
<summary><b>افتح للتفاصيل / Click to expand</b></summary>

افتح **PowerShell كـ Administrator** ونفّذ:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
iwr -useb https://raw.githubusercontent.com/soalhelp/Soal.Help/main/windows/install.ps1 | iex
```

الـ installer هيحاول يستخدم `winget` أو `scoop` أو `cargo` — لو مفيش، بيحمّل الثنائي مباشرة من GitHub Releases.

بعد التثبيت افتح **PowerShell جديد** وجرّب:
```powershell
aichat "hello!"
aichat -m gpt-5.5 "شرح React hooks"
```

**بديل GUI جاهز:** لو مش عايز terminal، حمّل [Chatbox](https://chatboxai.app) — واجهة رسومية مدعومة لويندوز/ماك/لينكس. من **Settings → API Provider → Custom OpenAI Compatible**:
- **API Host:** `https://soal.help/api/v1`
- **API Key:** `sk-...` بتاعك

[📖 الدليل التفصيلي](windows/)

</details>

---

## 🌐 كروم / Edge / Brave — Chrome Extension

<details>
<summary><b>افتح للتفاصيل / Click to expand</b></summary>

إضافة ذاتية الاستضافة — شات جانبي (Side Panel) بيقعد مفتوح جنب أي موقع.

**التثبيت:**
1. حمّل الريبو ده (Code → Download ZIP) أو `git clone`.
2. افتح `chrome://extensions/`.
3. اقلب **Developer mode** على من فوق يمين.
4. اضغط **Load unpacked** → اختار فولدر `chrome-extension`.
5. اضغط أيقونة الإضافة → صفحة Options → حط مفتاح API.
6. اضغط الأيقونة تاني → الـ Side Panel هيفتح على اليمين.

**الميزات:**
- 🌊 Streaming — الرد بيوصلك حرف حرف.
- 💰 عرض التكلفة والرصيد المتبقّي بعد كل رد.
- 🖱️ حدد أي نص في أي موقع → كليك يمين → «اسأل Soal.help عن النص المحدد».
- 🎨 RTL كامل — الواجهة عربي طبيعي.

[📖 الدليل التفصيلي](chrome-extension/)

</details>

---

## ⌨️ VSCode / Cursor — Continue.dev

<details>
<summary><b>افتح للتفاصيل / Click to expand</b></summary>

[Continue.dev](https://continue.dev) امتداد VSCode/Cursor بيحوّل الـ IDE بتاعك لـ Cursor. بيدعم OpenAI-compatible endpoints.

**التثبيت:**
1. ثبّت الإضافة من [continue.dev](https://continue.dev) في VSCode أو Cursor.
2. Ctrl+Shift+P → `Continue: Open config.json`.
3. استبدل محتواه بالإعداد الجاهز في [`vscode-cursor/continue-config.json`](vscode-cursor/continue-config.json).
4. استبدل `REPLACE_ME_WITH_SK_KEY` بمفتاحك.
5. احفظ ← اضغط `Ctrl+L` تفتح شات جنب المحرر.

[📖 الدليل التفصيلي](vscode-cursor/)

</details>

---

## 💻 مطوّرين — Developers

<details>
<summary><b>curl / Python / Node.js examples</b></summary>

الـ API متوافق 100% مع OpenAI SDK. غيّر بس الـ `base_url`:

**Python:**
```python
from openai import OpenAI

client = OpenAI(
    api_key="sk-YOUR_KEY",
    base_url="https://soal.help/api/v1",
)

resp = client.chat.completions.create(
    model="claude-haiku-4-5-20251001",
    messages=[{"role": "user", "content": "مرحبا"}],
)
print(resp.choices[0].message.content)
```

**Node.js:**
```javascript
import OpenAI from 'openai';

const client = new OpenAI({
  apiKey: 'sk-YOUR_KEY',
  baseURL: 'https://soal.help/api/v1',
});

const resp = await client.chat.completions.create({
  model: 'claude-haiku-4-5-20251001',
  messages: [{ role: 'user', content: 'مرحبا' }],
});
console.log(resp.choices[0].message.content);
```

**curl:**
```bash
curl -X POST https://soal.help/api/v1/chat/completions \
  -H "Authorization: Bearer sk-YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-haiku-4-5-20251001",
    "messages": [{"role": "user", "content": "مرحبا"}]
  }'
```

[📖 أمثلة كاملة](examples/)

</details>

---

## 🧠 الموديلات المتاحة / Available Models

| Category  | Models |
|-----------|--------|
| 💬 Chat   | `claude-haiku-4-5-20251001` · `claude-sonnet-4-5-20250929` · `claude-sonnet-4-6` · `claude-opus-4-7` · `claude-opus-4-8` · `gpt-5-mini` · `gpt-5.4` · `gpt-5.5` · `gpt-4o` · `gpt-4.1-mini` · `o3` · `o4-mini` · `gemini-2.5-pro` · `gemini-3.1-pro-preview` |
| 🖼️ Image  | `gemini-3.1-flash-image-preview` · `gemini-3-pro-image-preview` · `gpt-image-1` · `gemini-2.5-flash-image` |
| 🎬 Video  | `sora-2` · `sora-2-pro` |

القائمة الحيّة والتحديثة دايمًا: [soal.help/api/models](https://soal.help/api/models)

---

## 📁 هيكل الريبو / Repo Structure

```
soal-help/
├─ chrome-extension/     ← إضافة كروم Manifest V3 كاملة
├─ termux/               ← Codex CLI + config + launcher + doctor + reset
├─ linux-macos/          ← aichat installer + config
├─ windows/              ← PowerShell installer + config
├─ vscode-cursor/        ← Continue.dev config.json
├─ examples/             ← أمثلة curl / Python / Node.js
├─ LICENSE               ← MIT
└─ README.md             ← الملف ده
```

---

## 🛠️ مشاكل شائعة / Common Issues

<details>
<summary><b>❌ curl: (23) Failure writing output — عند تشغيل الـ installer</b></summary>

خطأ قديم من نسخة سابقة. النسخة الحالية بتستخدم `/dev/tty` مباشرة لكل `read` — بدل قطع الـ pipe. تأكد إنك بتشغّل من الفرع `main` وليس نسخة محلية قديمة.
</details>

<details>
<summary><b>❌ config.toml legacy profile error (Codex 0.145+)</b></summary>

الإصدارات الأحدث من Codex بترفض `[profiles.*]` جوّه config.toml. استخدم الـ launcher `soal` اللي بيمرّر `--model` مباشرة. لو الملف عندك قديم، شغّل `reset.sh` ثم `install.sh` تاني.
</details>

<details>
<summary><b>❌ Insufficient balance (402)</b></summary>

رصيدك خلص — اشحن من [soal.help/app/topup](https://soal.help/app/topup).
</details>

<details>
<summary><b>❌ Authentication failed (401)</b></summary>

المفتاح غلط أو منتهي. أنشئ واحد جديد من [soal.help/app/keys](https://soal.help/app/keys) وشغّل الـ installer تاني.
</details>

---

## 📌 روابط سريعة / Quick Links

- 🌐 الموقع: [soal.help](https://soal.help)
- 📊 لوحة التحكم: [soal.help/app/dashboard](https://soal.help/app/dashboard)
- 🔑 مفاتيح API: [soal.help/app/keys](https://soal.help/app/keys)
- 💰 شحن الرصيد: [soal.help/app/topup](https://soal.help/app/topup)
- 📖 دليل الربط: [soal.help/guide](https://soal.help/guide)
- ✅ تحقّق من أصالة الموديلات: [soal.help/app/verify](https://soal.help/app/verify)

---

## 🤝 المساهمة / Contributing

Pull requests مرحّب بها. لو أضفت دعم لعميل جديد (LM Studio, Cherry Studio, BoltAI, إلخ) — افتح PR.

## 📄 الترخيص / License

MIT — راجع ملف [LICENSE](LICENSE).

---

<div align="center">

**Made with ❤️ for Egyptian & Arab developers**

بُني بـ ❤️ للمطوّرين المصريين والعرب

[soal.help](https://soal.help)

</div>
