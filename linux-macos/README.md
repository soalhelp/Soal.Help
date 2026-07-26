# 🐧 Linux & macOS — دليل التثبيت الكامل

> **الفكرة:** هتشغّل موديلات Soal.help من الترمنال باستخدام `aichat` (أداة سريعة بلغة Rust).

---

## 🎁 إيه اللي هيتثبّت عليك؟

**مش لازم تسطّب أي حاجة بنفسك.** الـ Installer هيعمل كل حاجة لوحده:

| الأداة | إيه هي | حجمها | يتثبّت أوتوماتيك؟ |
|--------|--------|--------|--------------------|
| **aichat** | CLI بلغة Rust بيكلم الموديلات | ~10MB | ✅ الـ Installer بيسطّبها |
| **إعدادات Soal.help** | ملف Config بيربطها بموقعنا | صغير | ✅ الـ Installer بيسطّبها |
| **Alias `soal`** | اختصار عشان تكتب `soal` بدل `aichat` | — | ✅ الـ Installer بيضيفها |

يعني كل اللي عليك:
1. الصق **أمر واحد** في الترمنال (هيسطّب كل الباقي).
2. الصق **مفتاح API** بتاعك لما يطلبه.

**خلاص. مفيش أي حاجة تانية.**

---

## ✅ متطلبات

- 💻 لينكس (Ubuntu / Debian / Fedora / Arch) أو ماك (Intel أو Apple Silicon)
- 🌐 اتصال إنترنت
- 💰 حساب على [soal.help](https://soal.help) بيه رصيد
- ⏰ 3-5 دقايق

---

## 🚀 التثبيت في سطر واحد

افتح الترمنال:
- **Ubuntu/Debian:** اضغط `Ctrl+Alt+T`
- **macOS:** اضغط `Cmd+Space` واكتب `Terminal` وا**Enter**
- **Fedora/Arch:** من قايمة التطبيقات ← Terminal

انسخ الأمر ده كامل والصقه:

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/linux-macos/install.sh | bash
```

**إزاي تلصق في الترمنال:**
- **لينكس:** اضغط `Ctrl+Shift+V`
- **ماك:** اضغط `Cmd+V`

اضغط **Enter**.

---

## 🔍 اللي هيحصل خطوة خطوة

### الخطوة 1: كشف نظام التشغيل
```
[i] النظام: linux    (أو mac)
```

### الخطوة 2: تثبيت `aichat`
- **على ماك:** الأداة بتيجي من Homebrew (`brew install aichat`). لو Homebrew مش موجود بينزّل الثنائي مباشرة.
- **على لينكس:** بينزّل الثنائي من GitHub Releases ويحطه في `~/.local/bin/`.

```
[i] بأثبّت aichat...
[+] اتثبّت aichat
```

### الخطوة 3: طلب مفتاح API

الـ installer هيوقف ويطلب منك المفتاح:

```
اطلع مفتاح API من: https://soal.help/app/keys
الصق المفتاح (sk-...):
```

**دلوقتي بالظبط اعمل:**

1. **بدون ما تقفل الترمنال**، افتح المتصفح.
2. روح على: **[https://soal.help/app/keys](https://soal.help/app/keys)**
3. سجّل دخول لحسابك.
4. اضغط زرار **إنشاء مفتاح جديد**.
5. هيظهر مفتاح شكله كده:
   ```
   sk-a1b2c3d4e5f6...
   ```
6. **اعمل نسخ للمفتاح** (اضغط عليه ← Ctrl+C أو Cmd+C).
7. **ارجع للترمنال**.
8. الصق المفتاح (`Ctrl+Shift+V` لينكس، `Cmd+V` ماك).
9. اضغط **Enter**.

> ⚠️ **مهم:** لما تلصق المفتاح، ممكن يظهر في الترمنال (على عكس Termux). ده عادي.

### الخطوة 4: كتابة الإعدادات
```
[+] config.yaml → /home/YOU/.config/aichat/config.yaml
```

### الخطوة 5: إضافة alias
الـ installer بيضيف alias `soal` في `.bashrc`/`.zshrc` عشان تقدر تكتب `soal` بدل `aichat`.

---

## ✨ التجربة الأولى

**أول حاجة، افتح ترمنال جديد** (أو شغّل `source ~/.bashrc`).

```bash
# جلسة تفاعلية
aichat
```

هيفتح REPL بيسألك تكتب سؤالك:
```
>>> إزيك؟
[claude-haiku-4-5]
أهلاً! كل حاجة تمام. إزيك إنت؟

>>> _
```

اكتب `.exit` أو اضغط `Ctrl+D` للخروج.

**استخدامات تانية:**

```bash
# سؤال سريع (بدون جلسة)
aichat "قوللي معلومة عن الأهرامات"

# اختار موديل معيّن
aichat -m claude-opus-4-8 "اكتب لي محتوى موقع عن مطاعم القاهرة"
aichat -m gpt-5.5 "اشرحلي React server components"
aichat -m gemini-3.1-pro-preview "قوللي فرق GraphQL و REST"

# استخدم الـ alias المختصر
soal "أخبار التكنولوجيا النهاردة"

# pipe: مرّر محتوى ملف
cat error.log | aichat "لخّص الأخطاء دي وقولي إزاي أصلّحها"

# مساعدة على كود
cat main.py | aichat "راجع الكود ده"

# ملف كامل كسياق
aichat -f main.py "أعد كتابة الدالة الرئيسية"
```

---

## 🎨 بديل GUI (لو مش مرتاح للترمنال)

**[Chatbox](https://chatboxai.app)** — تطبيق desktop رسومي جميل، متوفر لكل الأنظمة.

**التثبيت:**
1. نزّل من [chatboxai.app](https://chatboxai.app).
2. افتح Chatbox.
3. اضغط الترس (⚙️) → **AI Provider**.
4. اختار **Custom Provider (OpenAI Compatible)**.
5. حط الإعدادات:
   - **API Host:** `https://soal.help/api/v1`
   - **API Key:** `sk-...` (المفتاح بتاعك)
   - **Model:** `claude-haiku-4-5-20251001` (أو أي موديل من [القايمة](https://soal.help/api/models))
6. اضغط **Save**.
7. اضغط **New Chat** واسأل!

**بدايل تانية بنفس الطريقة:**
- **[Cherry Studio](https://cherry-ai.com)** — دعم RTL أفضل للعربية
- **[Jan](https://jan.ai)** — مفتوح المصدر
- **[NextChat](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web)** — self-hosted

---

## 🚨 مشاكل شائعة

<details>
<summary><b>❌ "aichat: command not found"</b></summary>

الـ PATH ما اتحدّثش. شغّل:
```bash
source ~/.bashrc     # لينكس
source ~/.zshrc      # ماك (لو بتستخدم zsh)
```
لو لسّه مش شغال:
```bash
export PATH="$HOME/.local/bin:$PATH"
```
</details>

<details>
<summary><b>❌ ماك: "brew: command not found"</b></summary>

Homebrew مش مثبّت. سطّبه الأول:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
بعدها شغّل الـ installer تاني.
</details>

<details>
<summary><b>❌ "Authentication failed" لما بشغّل aichat</b></summary>

المفتاح غلط أو انتهت صلاحيته. **مش لازم تعدّل أي ملف يدوي** — شغّل الـ installer تاني بمفتاح جديد:

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/linux-macos/install.sh | bash
```
</details>

<details>
<summary><b>❌ "Insufficient balance"</b></summary>

الرصيد خلص. اشحن من [soal.help/app/topup](https://soal.help/app/topup).
</details>

---

## 🔄 عايز تغيّر المفتاح؟

مش محتاج تعدّل أي ملف يدوي — **شغّل الـ installer تاني**:

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/linux-macos/install.sh | bash
```

---

## 🧹 إلغاء التثبيت

**ماك (Homebrew):**
```bash
brew uninstall aichat
rm -rf ~/Library/Application\ Support/aichat
```

**لينكس (ثنائي مباشر):**
```bash
rm ~/.local/bin/aichat
rm -rf ~/.config/aichat
```

بعد كده احذف السطر `alias soal='aichat'` من `.bashrc` أو `.zshrc`.
