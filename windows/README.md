# 🖥️ Windows — دليل التثبيت الكامل

> **الفكرة:** هتشغّل موديلات Soal.help من PowerShell على ويندوز باستخدام **Codex CLI** — الوكيل الرسمي من OpenAI. بيقرأ ملفاتك وينفّذ أوامر ويعدّل الكود.

---

## 🎁 إيه اللي هيتثبّت عليك؟

| الأداة | يتثبّت أوتوماتيك؟ |
|--------|--------------------|
| **Codex CLI** (`@openai/codex`) | ✅ من npm |
| **إعدادات Soal.help** (`config.toml` + 18 profile) | ✅ من الـ installer |
| **Model catalog** | ✅ من الـ installer |

---

## ✅ متطلبات

- 🖥️ ويندوز **10 أو 11**
- 📦 **Node.js LTS** (لو مش مثبت، الـ installer هيقولك)
- 💰 حساب على [soal.help](https://soal.help) بيه رصيد

**لو Node.js مش موجود:**
```powershell
winget install OpenJS.NodeJS.LTS
```
أو نزّله يدوي من [nodejs.org](https://nodejs.org).

---

## 🚀 التثبيت خطوة خطوة

### الخطوة 1: افتح PowerShell كـ Administrator

- اضغط **Win** واكتب `powershell` → كليك يمين → **Run as administrator**.

### الخطوة 2: السماح بتشغيل الـ script

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
```

### الخطوة 3: شغّل الـ installer

```powershell
iwr -useb https://raw.githubusercontent.com/soalhelp/Soal.Help/main/windows/install.ps1 | iex
```

الـ installer هيسألك عن **مفتاح API** — الصقه من [soal.help/app/keys](https://soal.help/app/keys).

---

## ✨ التجربة الأولى

**افتح PowerShell جديد** (عشان الـ PATH يتحدّث):

```powershell
codex
codex --profile claude-sonnet-46
codex --profile gpt5
codex --profile gemini-pro
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
| `o3` | O3 | 200K |
| `o4-mini` | O4 Mini | 200K |
| `gemini-pro` | Gemini 3.1 Pro | 1M |
| `gemini-25-pro` | Gemini 2.5 Pro | 1M |
| `gemini-flash` | Gemini 3.5 Flash | 1M |
| `gemini-flash-3` | Gemini 3 Flash | 1M |
| `gemini-25-flash` | Gemini 2.5 Flash | 1M |

---

## 🚨 مشاكل شائعة

<details>
<summary><b>❌ "codex: The term 'codex' is not recognized"</b></summary>

اقفل PowerShell وافتحه تاني عشان الـ PATH يتحدّث. لو لسه بيقول كده:
```powershell
$env:PATH = "$(npm root -g)\..;" + $env:PATH
```
</details>

<details>
<summary><b>❌ "Node.js مش موجود"</b></summary>

```powershell
winget install OpenJS.NodeJS.LTS
```
أو نزّل من [nodejs.org](https://nodejs.org).
</details>

<details>
<summary><b>❌ "Authentication failed"</b></summary>

المفتاح غلط أو منتهي. شغّل الـ installer تاني.
</details>

---

## 🔄 عايز تغيّر المفتاح؟

```powershell
Remove-Item "$env:USERPROFILE\.codex\.env"
iwr -useb https://raw.githubusercontent.com/soalhelp/Soal.Help/main/windows/install.ps1 | iex
```

---

## 🧹 إلغاء التثبيت

```powershell
npm uninstall -g @openai/codex
Remove-Item -Recurse -Force "$env:USERPROFILE\.codex"
```
