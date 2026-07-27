# 📱 Termux (Android) — دليل التثبيت الكامل

> **الفكرة:** هتشغّل موديلات Soal.help (Claude, GPT, Gemini) من داخل تليفونك الأندرويد باستخدام Codex CLI (نفس أداة OpenAI الرسمية) — بس فورك مبني مخصوص للأندرويد.

---

## 🎁 إيه اللي هيتثبّت عليك؟

**مش لازم تسطّب أي حاجة بنفسك.** الـ Installer اللي هتشغّله في الخطوة 2 هيعمل كل حاجة لوحده:

| الأداة | إيه هي | حجمها | يتثبّت أوتوماتيك؟ |
|--------|--------|--------|--------------------|
| **Node.js** | لتشغيل Codex | ~30MB | ✅ الـ Installer بيسطّبها |
| **fzf** | لاختيار الموديل بسرعة | ~1MB | ✅ الـ Installer بيسطّبها |
| **Codex CLI** | الأداة اللي بتكلم الموديلات | ~40MB | ✅ الـ Installer بيسطّبها |
| **إعدادات Soal.help** | ملف Config بيربطها بموقعنا | صغير | ✅ الـ Installer بيسطّبها |

يعني كل اللي عليك:
1. سطّب **Termux** بنفسك (خطوة واحدة من F-Droid).
2. الصق **أمر واحد** في Termux (هيسطّب كل الباقي).
3. الصق **مفتاح API** بتاعك لما يطلبه.

**خلاص. مفيش أي حاجة تانية.**

---

## 📁 الملفات اللي هتتعمل على جهازك

بعد التثبيت، هيبقى عندك:

| الملف | فيه إيه |
|-------|---------|
| `~/.codex/config.toml` | إعدادات Codex الرئيسية (مزوّد Soal.help، الموديل الافتراضي، إلخ) |
| `~/.codex/.env` | مفتاح API بتاعك (صلاحيات 600 — إنت بس تقدر تقراه) |
| `~/bin/soal` | الـ launcher — بيمررلك أوامر لـ Codex بالموديل اللي تختاره |

**شكل ملف `~/.codex/.env`:**
```bash
# Soal.help API key — do not share.
export SOAL_API_KEY="sk-ac6f999cfff0b053d3c46779f4e45252353acfdfa6910532"
```

**شكل ملف `~/.codex/config.toml`:**
```toml
model_provider = "soal"
model = "claude-haiku-4-5-20251001"
sandbox_mode = "workspace-write"
approval_policy = "on-request"

[model_providers.soal]
name = "Soal.help"
base_url = "https://soal.help/api/v1"
env_key = "SOAL_API_KEY"
wire_api = "chat"
```

---

## 🧠 كل الموديلات المدعومة

18 موديل جاهز في الـ launcher — كل موديل ليه **Profile** بنفس الاسم في `config.toml` بحدود الـ Context الرسمية بتاعته، فمفيش تحذير "unknown model" ولا تقطيع في المحادثات الطويلة. شوفهم بأمر واحد:

```bash
soal --list
```

| Alias | Model ID | Context | الاستخدام |
|-------|----------|---------|-----------|
| `claude-haiku` | claude-haiku-4-5-20251001 | 200K | سريع ورخيص |
| `claude-sonnet` | claude-sonnet-4-5-20250929 | 200K | متوازن |
| `claude-sonnet-46` | claude-sonnet-4-6 | 1M | متوازن (أحدث) |
| `claude-opus` | claude-opus-4-8 | 1M | أقوى موديل Claude |
| `claude-opus-47` | claude-opus-4-7 | 1M | Opus الجيل السابق |
| `claude-fable` | claude-fable-5 | 1M | سياق ضخم |
| `gpt-mini` | gpt-5-mini | 400K | GPT سريع |
| `gpt5` | gpt-5.5 | 1M | GPT متقدّم |
| `gpt54` | gpt-5.4 | 1M | GPT-5.4 |
| `gpt-4o` | gpt-4o | 128K | GPT-4o |
| `gpt41-mini` | gpt-4.1-mini | 1M | سياق كبير رخيص |
| `o3` | o3 | 200K | تفكير عميق |
| `o4-mini` | o4-mini | 200K | تفكير سريع |
| `gemini-pro` | gemini-3.1-pro-preview | 1M | Gemini 3.1 Pro |
| `gemini-25-pro` | gemini-2.5-pro | 1M | Gemini 2.5 Pro |
| `gemini-flash` | gemini-3.5-flash | 1M | Gemini سريع |
| `gemini-flash-3` | gemini-3-flash-preview | 1M | Gemini 3 Flash |
| `gemini-25-flash` | gemini-2.5-flash | 1M | الأرخص |

**استخدام:**
```bash
soal                          # قائمة تفاعلية (fzf)
soal claude-opus              # يشغّل Claude Opus مباشرة
soal gpt5 "اكتب دالة Python"  # يشغّل GPT-5.5 + prompt
codex --profile gemini-pro    # أو استخدم الـ profile مباشرة
```

---

## 💡 اختار الموديل الصح لمشروعك

الموديلات الصغيرة (Haiku, GPT-4o, GPT Mini, O3, O4-Mini) بسياق **200K/128K/400K** بتشتغل ممتاز في:
- ✅ أسئلة سريعة، محادثة قصيرة
- ✅ مشروع صغير (5-10 ملفات)
- ✅ debugging ملف واحد

**لكن لو المشروع فيه ملفات كتير أو الـ Codex هيقرا كود ضخم**، الموديل الصغير هيبدأ:
- يخلط الردود، يفقد سياق، أو يعلّق في auto-compact loop.

**للمشاريع الكبيرة استخدم موديلات 1M context:**

| الأفضل للـ Coding | الأفضل للسياق الكبير |
|---|---|
| `claude-sonnet-46` — دقة عالية | `gpt-5.5` — أفضل شامل |
| `claude-opus` — أقوى | `gemini-pro` — سياق ضخم |
| `gpt5` / `gpt54` | `claude-fable` |

**كقاعدة:** فتحت Codex في مجلد فيه أكتر من 20 ملف؟ ابدأ بـ `soal claude-sonnet-46` أو `soal gpt5`.

---

## ✅ متطلبات قبل ما تبدأ

- 📱 تليفون أندرويد إصدار **10 أو أحدث** (API 29+)
- 🔧 معالج **ARM64** (كل التليفونات الحديثة كده)
- 💰 حساب على [soal.help](https://soal.help) بيه رصيد
- ⏰ حوالي **10 دقايق** وقت (معظمها استنى تحميل)

---

## 🔽 الخطوة 1: تثبيت Termux على تليفونك

> **مهم جدًا:** لازم تنزّل Termux من **F-Droid** — نسخة **Play Store قديمة ومش هتشتغل**.

1. من المتصفح على تليفونك، افتح الرابط ده:
   👉 **[https://f-droid.org/en/packages/com.termux/](https://f-droid.org/en/packages/com.termux/)**

2. اضغط زرار **Download APK** (أزرق كبير في نصف الصفحة).

3. لما ينزّل، افتح الملف من الإشعارات (أو من مجلد Downloads).

4. لو ظهرت رسالة **«تثبيت من مصدر مجهول»** — اضغط **السماح** → **تثبيت**.

5. افتح تطبيق **Termux** من درج التطبيقات.

6. أول ما يفتح هتلاقي شاشة سودا فيها سطر بيقول:
   ```
   ~ $
   ```
   ده معناه إن Termux جاهز يستقبل أوامر.

---

## 🚀 الخطوة 2: تشغيل الـ Installer

انسخ الأمر ده كله والصقه في Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux/install.sh | bash
```

**إزاي تلصق في Termux؟**
- اضغط مطوّل بإصبعك في نص الشاشة السودا
- هتلاقي زرار **Paste** — اضغطه
- لما يظهر الأمر، اضغط **Enter** (زرار الرجوع في الكيبورد)

**اللي هيحصل بعد كده:**

الـ installer هيمشي في 6 خطوات — كل خطوة هيقولك عليها. متقفلش Termux وسيبه شغّال حتى لو مشيت من التطبيق (Termux بيفضل شغال في الخلفية).

### 🔍 ماذا تتوقع في كل خطوة:

| الخطوة | إيه اللي بيحصل | الوقت المتوقع |
|--------|-----------------|----------------|
| 1️⃣ الفحص المبدئي | يتأكد إنك في Termux | ثانية |
| 2️⃣ تحديث الحزم | ينزّل Node.js و fzf | 1-3 دقايق |
| 3️⃣ تثبيت Codex | ينزّل Codex CLI من npm | 2-5 دقايق ⚠️ |
| 4️⃣ مفتاح API | **هيسألك عن المفتاح** — شوف تحت | ثانية |
| 5️⃣ ملفات الإعداد | ينسخ config + launcher | ثانية |
| 6️⃣ تحديث الـ shell | يعدّل bashrc | ثانية |

---

## 🔑 الخطوة 3: لما يطلب منك مفتاح API

في الخطوة الرابعة، الـ installer هيوقف ويطلع لك الرسالة دي:

```
━━━ الخطوة 4 من 6 — مفتاح API بتاع Soal.help ━━━

عشان النظام يشتغل محتاج مفتاح API من حسابك على soal.help.

  الخطوات:
  1) افتح المتصفح على الرابط ده:
     https://soal.help/app/keys
  2) اضغط زرار «إنشاء مفتاح جديد»
  3) هيظهر مفتاح شكله كده: sk-abc123...
  4) اعمل نسخ للمفتاح كله (اضغط عليه مطوّل ← نسخ)
  5) ارجع لهنا والصقه تحت (اضغط مطوّل في الشاشة السودا ← Paste)

  ملاحظة: لما تلصق المفتاح مش هيظهر على الشاشة (ده طبيعي — للأمان).

الصق مفتاح API واضغط Enter:
```

**دلوقتي بالظبط اعمل:**

1. **من غير ما تقفل Termux**، افتح متصفحك (Chrome / Samsung Internet / إلخ).
2. روح على: **[https://soal.help/app/keys](https://soal.help/app/keys)**
3. سجّل دخول لحسابك.
4. اضغط زرار **إنشاء مفتاح جديد** (لونه أصفر/برتقالي).
5. هيظهر مفتاح شكله كده تقريبًا:
   ```
   sk-a1b2c3d4e5f6...
   ```
6. اضغط عليه مطوّل بإصبعك ← **Copy** (نسخ).
7. **افتح Termux تاني** (من قايمة التطبيقات المفتوحة).
8. اضغط مطوّل في نص الشاشة السودا ← **Paste**.
9. **مهم جدًا:** لما تلصق، **الشاشة مش هتظهر أي حاجة** — ده طبيعي. المفتاح اتلصق، بس التطبيق مش بيعرضه لأسباب أمنية.
10. اضغط **Enter**.

**لو المفتاح صح:**
```
[+] المفتاح اتحفظ في /data/data/com.termux/files/home/.codex/.env
```

**لو المفتاح غلط:**
```
[!] المفتاح مش صحيح — لازم يبدأ بـ sk- وطوله معقول. حاول تاني (محاولة 1/3).
```
عندك 3 محاولات.

---

## ✨ الخطوة 4: التجربة الأولى

بعد ما الـ installer يخلّص، هتشوف:

```
✔✔✔ التثبيت خلص بنجاح! ✔✔✔

جرّب دلوقتي:
  soal                          ← قائمة اختيار الموديل
  soal claude-opus              ← يشتغل مباشرة على Claude Opus
  soal gpt5 "إزيك؟"             ← يشتغل + سؤال
```

**جرّب أول أمر:**
```bash
soal
```

هتظهر قائمة تفاعلية تختار منها الموديل:
```
اختر بروفايل Soal.help:
> claude-haiku        (claude-haiku-4-5-20251001)
  claude-sonnet       (claude-sonnet-4-5-20250929)
  claude-sonnet-46    (claude-sonnet-4-6)
  claude-opus         (claude-opus-4-8)
  gpt-mini            (gpt-5-mini)
  gpt5                (gpt-5.5)
  ...
```

استخدم الأسهم (↑↓) للتنقّل، وا**نقر Enter** على الموديل اللي عايزه. Codex هيفتح وتقدر تكلّمه عادي.

---

## 🎯 أوامر يومية بعد التثبيت

```bash
# قائمة اختيار سريعة
soal

# اشتغل على موديل معيّن مباشرة (بدون قايمة)
soal claude-opus
soal gpt5
soal gemini-pro

# ابعت سؤال مباشر من غير ما تدخل الجلسة
soal claude-haiku "اكتبلي دالة Python بترجع Fibonacci"

# لو مش عايز الـ launcher وعايز Codex مباشرة
codex --profile claude-opus
```

---

## 🚨 مشاكل شائعة وحلولها

<details>
<summary><b>❌ "codex: command not found"</b></summary>

الـ PATH ما اتحدّثش. شغّل:
```bash
source ~/.bashrc
```
لو لسّه مش شغال، اقفل Termux تمامًا (من settings → force stop) وافتحه تاني.
</details>

<details>
<summary><b>❌ "npm: command not found"</b></summary>

Node.js ما اتثبّتش. شغّل يدويًا:
```bash
pkg install -y nodejs-lts
```
</details>

<details>
<summary><b>❌ الـ installer وقف عند "بأثبّت @mmmbuto/codex-cli-termux"</b></summary>

ده طبيعي — بياخد 2-5 دقايق. لو دقّت 10 دقايق ولسّه واقف، اضغط Ctrl+C وشغّل يدويًا:
```bash
npm install -g @mmmbuto/codex-cli-termux@latest
```
لو ظهر خطأ Permission denied:
```bash
npm config set prefix ~/.local
export PATH="$HOME/.local/bin:$PATH"
npm install -g @mmmbuto/codex-cli-termux@latest
```
</details>

<details>
<summary><b>❌ الـ installer قال "معرفتش ألاقي مفتاح" 3 مرات</b></summary>

معناها إنك ما لصقتش شيء أصلاً، أو الشاشة أخدت بس جزء من المفتاح. **مش لازم تعمل حاجة يدوي** — بس شغّل الـ installer تاني:

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux/install.sh | bash
```

وهذه المرة:
- افتح المتصفح على [soal.help/app/keys](https://soal.help/app/keys)
- أنشئ مفتاح جديد
- اضغط عليه مطوّل بإصبعك ← نسخ (المفتاح كله بيتنسخ لوحده)
- ارجع لـ Termux، اضغط مطوّل في الشاشة ← Paste
- اضغط Enter

**الـ installer شاطر جدًا** — بيستخرج المفتاح من أي شكل انت لصقته (حتى لو كان `sk-...` لوحده أو `OPENROUTER_API_KEY="sk-..."` أو أي حاجة تانية).
</details>

<details>
<summary><b>❌ Codex بيقول "no API key" لما بشغّل soal</b></summary>

المفتاح مش بيتلقّم في الجلسة. اقفل Termux وافتحه تاني، أو شغّل:
```bash
source ~/.codex/.env
```
</details>

---

## 🔄 عايز تغيّر المفتاح؟

مش محتاج تعدّل أي ملف يدوي — **شغّل الـ installer تاني**:

```bash
curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux/install.sh | bash
```

هيعرف إن فيه مفتاح قديم ويستبدله بالجديد.

---

## 🧹 إلغاء التثبيت

```bash
npm uninstall -g @mmmbuto/codex-cli-termux
rm -rf ~/.codex
rm ~/bin/soal
```

---

## 📚 موارد إضافية

- **الموقع الرئيسي:** [soal.help](https://soal.help)
- **الرصيد بتاعك:** [soal.help/app/dashboard](https://soal.help/app/dashboard)
- **الفورك الأصلي لـ Codex-Termux:** [github.com/DioNanos/codex-termux](https://github.com/DioNanos/codex-termux)
- **npm package:** [@mmmbuto/codex-cli-termux](https://www.npmjs.com/package/@mmmbuto/codex-cli-termux)
