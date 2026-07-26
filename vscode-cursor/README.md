# ⌨️ VSCode / Cursor — Soal.help

**عربي:** يربط [Continue.dev](https://continue.dev) بموديلات Soal.help — يديك Cursor-like experience جوّه VSCode.
**English:** Wires [Continue.dev](https://continue.dev) to Soal.help models — Cursor-like AI inside VSCode.

## الخطوات

### 1) ثبّت Continue Extension
- **VSCode:** ابحث عن "Continue" في Extensions أو من [marketplace](https://marketplace.visualstudio.com/items?itemName=Continue.continue).
- **Cursor:** جاي من ضمن التنصيب الأساسي.
- **JetBrains:** [ide.continue.dev](https://ide.continue.dev).

### 2) افتح ملف الإعدادات
- في VSCode/Cursor: `Ctrl+Shift+P` (أو `Cmd+Shift+P` على ماك) → اكتب `Continue: Open config.json`.
- بيفتح ملف `~/.continue/config.json`.

### 3) استبدل المحتوى
استبدل محتوى الملف بالكامل بالإعداد الجاهز في [`continue-config.json`](continue-config.json).

بعد اللصق، **استبدل `REPLACE_ME_WITH_SK_KEY`** (بيتكرّر 7 مرات) بمفتاحك.

نصيحة: `Ctrl+H` (Find & Replace) — دور على `REPLACE_ME_WITH_SK_KEY` واستبدلها كلها مرة واحدة.

### 4) احفظ ← ريستارت VSCode
اضغط `Ctrl+L` وشات فى الـ sidebar هيفتح.

## الاختصارات الأساسية

| اختصار          | إيه بيعمل |
|-----------------|-----------|
| `Ctrl+L`        | فتح الشات الجانبي |
| `Ctrl+I`        | تعديل الكود المحدد بالـ AI |
| `Ctrl+Shift+L`  | إضافة الكود المحدد للشات |
| `@file`         | يمرّر ملف معيّن للـ AI |
| `@codebase`     | يبحث في كل ملفات المشروع |
| `@docs`         | يبحث في التوثيق |

## نصايح

- **للـ autocomplete (Tab):** الإعداد الحالي مربوط `claude-haiku` — سريع ورخيص.
- **للتعديلات الكبيرة:** خش على الشات واختار `Claude Opus 4.8` أو `GPT-5.5`.
- **لو Continue بطيء:** جرّب موديل أخف (`gpt-5-mini`, `claude-haiku`).

## نصيحة أمان

لا تتحّط `continue-config.json` بمفتاحك على GitHub — أضفه لـ `.gitignore`.
