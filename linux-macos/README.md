# 🐧 Linux & macOS — دليل التثبيت الكامل

> **الفكرة:** هتشغّل موديلات Soal.help من الترمنال باستخدام **Codex CLI** — الوكيل الرسمي من OpenAI. بيقرأ ملفاتك، بينفّذ أوامر، وبيعدّل الكود عندك مباشرة.

---

## 🎁 إيه اللي هيتثبّت عليك؟

**مش لازم تسطّب أي حاجة بنفسك.** الـ Installer هيعمل كل حاجة لوحده:

| الأداة | إيه هي | يتثبّت أوتوماتيك؟ |
|--------|--------|--------------------|
| **Codex CLI** (`@openai/codex`) | وكيل ترمنال بيقرأ ملفاتك وينفّذ أوامر | ✅ الـ Installer بيسطّبه |
| **إعدادات Soal.help** | `config.toml` + 18 profile للموديلات | ✅ الـ Installer بيكتبها |
| **Model catalog** | ملف بيشيل تحذير "Unknown model" ويضبط حدود الـ context | ✅ الـ Installer بيكتبه |

يعني كل اللي عليك:
1. الصق **أمر واحد** في الترمنال.
2. الصق **مفتاح API** بتاعك لما يطلبه.

**خلاص. مفيش أي حاجة تانية.**

---

## ✅ متطلبات

- 💻 لينكس (Ubuntu / Debian / Fedora / Arch) أو ماك (Intel أو Apple Silicon)
- 📦 **Node.js** (لو مش مثبت، الـ installer هيقولك تسطّبه)
- 🌐 اتصال إنترنت
- 💰 حساب على [soal.help](https://soal.help) بيه رصيد

---

## 🚀 التثبيت في سطر واحد

انسخ الأمر ده كامل والصقه في الترمنال:

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/linux-macos/install.sh | bash
```

---

## 🔍 اللي هيحصل خطوة خطوة

### الخطوة 1: التأكد من Node.js
```
[i] Node.js: v22.x.x
```

لو مش مثبّت، هيقولك تسطّبه:
- **Ubuntu/Debian:** `sudo apt install nodejs npm`
- **Fedora:** `sudo dnf install nodejs npm`
- **macOS:** `brew install node`

### الخطوة 2: تثبيت Codex CLI
```
[i] بأثبّت @openai/codex...
[✔] اتثبّت: 0.145.0
```

### الخطوة 3: طلب مفتاح API
```
اطلع مفتاح API من: https://soal.help/app/keys
الصق مفتاح API:
```

- افتح [soal.help/app/keys](https://soal.help/app/keys) في متصفح.
- اضغط **إنشاء مفتاح جديد** → انسخه.
- ارجع للترمنال والصقه (`Ctrl+Shift+V` لينكس / `Cmd+V` ماك) → **Enter**.

### الخطوة 4: كتابة الإعدادات
```
[✔] الإعدادات + 18 profile → /home/YOU/.codex/
```

---

## ✨ التجربة الأولى

**افتح ترمنال جديد** (أو شغّل `source ~/.bashrc`).

```bash
# محادثة تفاعلية على الموديل الافتراضي (Haiku 4.5)
codex

# اختار موديل معيّن
codex --profile claude-sonnet-46
codex --profile claude-opus
codex --profile gpt5
codex --profile gemini-pro
```

الوكيل بيقدر يقرأ ملفاتك وينفّذ أوامر في الترمنال:

```
> اقرأ ملف package.json وقولي إيه الـ dependencies اللي محتاجة تحديث

• Read package.json
• Explored dependencies
• I found 3 outdated packages: react, axios, and moment...
```

---

## 📋 الموديلات المتاحة

18 موديل جاهزين، كل واحد بـ profile:

| Profile | الموديل | السياق |
|---------|--------|--------|
| `claude-haiku` | Claude Haiku 4.5 | 200K |
| `claude-sonnet` | Claude Sonnet 4.5 | 200K |
| `claude-sonnet-46` | Claude Sonnet 4.6 | 1M |
| `claude-opus` | Claude Opus 4.8 | 1M |
| `claude-opus-47` | Claude Opus 4.7 | 1M |
| `claude-fable` | Claude Fable 5 | 1M |
| `gpt-mini` | GPT-5 Mini | 400K |
| `gpt5` | GPT-5.5 | 1M |
| `gpt54` | GPT-5.4 | 1M |
| `gpt-4o` | GPT-4o | 128K |
| `gpt41-mini` | GPT-4.1 Mini | 1M |
| `o3` | O3 (تفكير عميق) | 200K |
| `o4-mini` | O4 Mini | 200K |
| `gemini-pro` | Gemini 3.1 Pro | 1M |
| `gemini-25-pro` | Gemini 2.5 Pro | 1M |
| `gemini-flash` | Gemini 3.5 Flash | 1M |
| `gemini-flash-3` | Gemini 3 Flash | 1M |
| `gemini-25-flash` | Gemini 2.5 Flash | 1M |

---

## 🚨 مشاكل شائعة

<details>
<summary><b>❌ "codex: command not found"</b></summary>

الـ PATH ما اتحدّثش. شغّل:
```bash
source ~/.bashrc   # أو ~/.zshrc على ماك
```
لو npm بيسطّب في مكان مش في الـ PATH، جرّب:
```bash
export PATH="$(npm bin -g):$PATH"
```
</details>

<details>
<summary><b>❌ "Node.js مش موجود"</b></summary>

سطّب Node.js الأول:
- **Ubuntu/Debian:** `sudo apt install nodejs npm`
- **Fedora:** `sudo dnf install nodejs npm`
- **Arch:** `sudo pacman -S nodejs npm`
- **macOS:** `brew install node`

بعدها شغّل الـ installer تاني.
</details>

<details>
<summary><b>❌ "Authentication failed"</b></summary>

المفتاح غلط أو منتهي. شغّل الـ installer تاني هيسألك عن مفتاح جديد.
</details>

<details>
<summary><b>❌ "Insufficient balance"</b></summary>

الرصيد خلص. اشحن من [soal.help/app/topup](https://soal.help/app/topup).
</details>

---

## 🔄 عايز تغيّر المفتاح؟

امسح ملف الـ env وشغّل تاني:

```bash
rm ~/.codex/.env
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/linux-macos/install.sh | bash
```

---

## 🧹 إلغاء التثبيت

```bash
npm uninstall -g @openai/codex
rm -rf ~/.codex
```

بعدين احذف السطر اللي فيه `.codex/.env` من `~/.bashrc` أو `~/.zshrc`.
