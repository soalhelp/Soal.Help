# 🖥️ Windows — دليل التثبيت الكامل

> **الفكرة:** هتشغّل موديلات Soal.help من PowerShell على ويندوز باستخدام `aichat`.

---

## 🎁 إيه اللي هيتثبّت عليك؟

**مش لازم تسطّب أي حاجة بنفسك.** الـ Installer هيعمل كل حاجة لوحده:

| الأداة | إيه هي | حجمها | يتثبّت أوتوماتيك؟ |
|--------|--------|--------|--------------------|
| **aichat** | CLI بلغة Rust بيكلم الموديلات | ~10MB | ✅ الـ Installer بيسطّبها |
| **إعدادات Soal.help** | ملف Config بيربطها بموقعنا | صغير | ✅ الـ Installer بيسطّبها |

يعني كل اللي عليك:
1. افتح **PowerShell**.
2. الصق **أمرين** (هيسطّبوا كل الباقي).
3. الصق **مفتاح API** بتاعك لما يطلبه.

**خلاص. مفيش أي حاجة تانية.**

> **بديل بدون PowerShell:** لو مش مرتاح لسطر الأوامر، استخدم **Chatbox** — تطبيق ويندوز رسومي جاهز. شوف قسم «بديل GUI» تحت.

---

## ✅ متطلبات

- 🖥️ ويندوز **10 أو 11**
- 💰 حساب على [soal.help](https://soal.help) بيه رصيد
- ⏰ 3-5 دقايق

---

## 🚀 التثبيت خطوة خطوة

### الخطوة 1: افتح PowerShell كـ Administrator

**الطريقة 1 (الأسرع):**
1. اضغط زرار **Windows** على الكيبورد.
2. اكتب: `powershell`
3. **مهم:** كليك يمين على **Windows PowerShell** في نتايج البحث.
4. اختار **Run as administrator** (تشغيل كمسؤول).
5. لو سألك User Account Control ← اضغط **Yes**.

**الطريقة 2:**
1. اضغط `Win + X` (كيبورد).
2. اختار **Terminal (Admin)** أو **PowerShell (Admin)**.

هتفتح شاشة زرقا فيها سطر بيقول:
```
PS C:\WINDOWS\system32>
```

### الخطوة 2: السماح بتشغيل الـ script

انسخ السطر ده والصقه:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
```

اضغط Enter. ده بيسمح بتشغيل scripts في الجلسة الحالية بس (آمن).

**إزاي تلصق في PowerShell:** كليك يمين في الشاشة بيلصق تلقائيًا.

### الخطوة 3: شغّل الـ Installer

انسخ الأمر ده كامل:

```powershell
iwr -useb https://raw.githubusercontent.com/soalhelp/Soal.Help/main/windows/install.ps1 | iex
```

اضغط Enter.

---

## 🔍 اللي هيحصل خطوة خطوة

### 1. تثبيت `aichat`
الـ Script هيحاول بالترتيب:
1. `winget install sigoden.aichat` (ويندوز 11 غالبًا)
2. `scoop install aichat` (لو Scoop مثبّت)
3. `cargo install aichat` (لو Rust مثبّت)
4. تحميل ثنائي مباشر من GitHub Releases

```
[i] aichat مش مثبّت. بحاول أثبّته...
[+] اتثبّت aichat
```

### 2. طلب مفتاح API

```
اطلع مفتاح API من: https://soal.help/app/keys
الصق المفتاح (sk-...):
```

**دلوقتي بالظبط اعمل:**

1. **بدون ما تقفل PowerShell**، افتح المتصفح (Edge / Chrome).
2. روح على: **[https://soal.help/app/keys](https://soal.help/app/keys)**
3. سجّل دخول لحسابك.
4. اضغط زرار **إنشاء مفتاح جديد**.
5. هيظهر مفتاح شكله كده:
   ```
   sk-a1b2c3d4e5f6...
   ```
6. **اعمل نسخ للمفتاح** (`Ctrl+C`).
7. **ارجع لـ PowerShell** (من التاسك بار).
8. **كليك يمين** في الشاشة (بيلصق تلقائيًا).
9. اضغط **Enter**.

### 3. كتابة الـ config
```
[+] config.yaml → C:\Users\YOU\AppData\Roaming\aichat\config.yaml
```

### 4. تحديث الـ PATH
الـ Script بيضيف مسار `aichat` لمتغيّرات البيئة User-level.

```
[+] التثبيت اكتمل!
```

---

## ✨ التجربة الأولى

⚠️ **مهم:** **اقفل PowerShell القديم وافتح واحد جديد** (عشان يحمّل الـ PATH المحدّث).

```powershell
# جلسة تفاعلية
aichat
```

مثال:
```
>>> إزيك؟
[claude-haiku-4-5]
أهلاً! كل حاجة تمام. إنت عامل إيه؟

>>> _
```

اكتب `.exit` أو اضغط `Ctrl+D` للخروج.

**استخدامات تانية:**
```powershell
# سؤال سريع
aichat "قوللي معلومة عن الأهرامات"

# اختار موديل
aichat -m claude-opus-4-8 "اكتب مقالة"
aichat -m gpt-5.5 "اشرح React hooks"
aichat -m gemini-3.1-pro-preview "قوللي فرق REST و GraphQL"

# pipe: مرّر محتوى ملف
type error.log | aichat "لخّص الأخطاء دي"

# ملف كامل كسياق
aichat -f main.py "راجع الكود ده"
```

---

## 🎨 بديل GUI جاهز (لغير المطوّرين)

**[Chatbox](https://chatboxai.app)** — تطبيق ويندوز رسومي جميل، مفيهوش أي terminal.

### التثبيت:
1. روح على [chatboxai.app](https://chatboxai.app).
2. اضغط **Download for Windows** ← بيحمل ملف `.exe`.
3. اشغّل الملف ← Next Next Finish.
4. افتح Chatbox من قائمة Start.

### الإعداد:
1. اضغط الترس (⚙️) في أسفل يسار.
2. **AI Provider** ← **Add Custom Provider**.
3. اختار **OpenAI Compatible**.
4. حط الإعدادات:
   - **Name:** Soal.help
   - **API Host:** `https://soal.help/api/v1`
   - **API Key:** `sk-...` (بتاعك)
   - **Model:** `claude-haiku-4-5-20251001`
5. اضغط **Save**.
6. من الصفحة الرئيسية ← **New Chat** ← اكتب أول سؤال!

### إضافة موديلات تانية:
في نفس صفحة الإعدادات، تحت **Model**، اضغط **Add Model** وضيف:
- `claude-sonnet-4-6`
- `claude-opus-4-8`
- `gpt-5.5`
- `gpt-5-mini`
- `gemini-3.1-pro-preview`
- ... إلخ

---

## 🚨 مشاكل شائعة

<details>
<summary><b>❌ "aichat is not recognized as an internal or external command"</b></summary>

الـ PATH ما اتحدّثش. **اقفل PowerShell وافتح واحد جديد**. لو لسّه مش شغال:
```powershell
$env:PATH = "$env:LOCALAPPDATA\aichat;$env:PATH"
```
</details>

<details>
<summary><b>❌ "cannot be loaded because running scripts is disabled"</b></summary>

نسيت الخطوة الأولى. شغّل:
```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
```
وبعدها كرّر الأمر اللي فشل.
</details>

<details>
<summary><b>❌ "winget: command not found"</b></summary>

`winget` مش موجود (ويندوز 10 القديم). ثبّته من Microsoft Store: ابحث عن **App Installer** ← Install/Update. أو استخدم `scoop`:
```powershell
iex "& {$(irm get.scoop.sh)}"
scoop install aichat
```
</details>

<details>
<summary><b>❌ "Authentication failed" لما بشغّل aichat</b></summary>

المفتاح غلط أو انتهت صلاحيته. **مش لازم تعدّل أي ملف يدوي** — شغّل الـ installer تاني بمفتاح جديد:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
iwr -useb https://raw.githubusercontent.com/soalhelp/Soal.Help/main/windows/install.ps1 | iex
```
</details>

---

## 🔄 عايز تغيّر المفتاح؟

مش محتاج تعدّل أي ملف يدوي — **شغّل الـ installer تاني**:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
iwr -useb https://raw.githubusercontent.com/soalhelp/Soal.Help/main/windows/install.ps1 | iex
```

---

## 🧹 إلغاء التثبيت

```powershell
# لو مثبّت عبر winget
winget uninstall sigoden.aichat

# لو مثبّت عبر scoop
scoop uninstall aichat

# لو مثبّت مباشرة (ثنائي)
Remove-Item -Recurse "$env:LOCALAPPDATA\aichat"

# احذف الإعدادات
Remove-Item -Recurse "$env:APPDATA\aichat"
```
