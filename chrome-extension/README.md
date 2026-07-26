# Soal.help Chrome Extension

> **ملخّص:** إضافة كروم فيها شات جانبي (Side Panel) بتوصلك على كل موديلات
> Soal.help بمفتاح API واحد. تستخدم Manifest V3 وتخزّن المفتاح محليًا في
> `chrome.storage.local` — مفيش أي سيرفر وسيط.

<div align="center">
  <img src="icons/icon128.png" width="96" alt="Soal.help" />
</div>

---

## 🇪🇬 التركيب على كروم / Edge / Brave

1. حمّل الفولدر ده كامل (أو `git clone` للريبو كله).
2. افتح `chrome://extensions` واقلب **Developer mode** على.
3. اضغط **Load unpacked** ← اختار فولدر `chrome-extension`.
4. الإضافة هتظهر — اضغط عليها من التولبار أو من الـ Puzzle Icon.
5. أول مرة هتفتح صفحة **Options** — اكتب:
   - **مفتاح API** (من صفحة [مفاتيح API](https://soal.help/app/keys) في حسابك، شكله `sk-...`)
   - **الموديل الافتراضي**
6. احفظ، وبعدها اضغط أيقونة الإضافة يفتح الشات الجانبي.

## 🇬🇧 Install (Chrome / Edge / Brave)

1. Download this folder (or `git clone` the whole repo).
2. Open `chrome://extensions` and toggle **Developer mode** on.
3. Click **Load unpacked** → pick the `chrome-extension` folder.
4. Pin the extension from the puzzle icon.
5. First launch opens **Options** — paste:
   - **API Key** from [soal.help/app/keys](https://soal.help/app/keys) (format `sk-...`)
   - **Default model**
6. Save, then click the extension icon to open the side panel and start chatting.

---

## ✨ الميزات / Features

- 🗨️ **شات جانبي (Side Panel)** بيقعد مفتوح جنب أي موقع بتصفّحه.
- 🌊 **Streaming** حقيقي — الرد بيظهر حرف حرف.
- 🎨 **RTL** أول درجة (Cairo font، layout عربي).
- 🔀 **تبديل موديلات** لحظي (Claude, GPT, Gemini، إلخ) من التوپبار.
- 💰 **عرض الرصيد** بعد كل رد (بيقرا `x_billing.balance_after_egp` من الـ payload).
- 🖱️ **قائمة سياق** — تحدد أي نص في صفحة ويب وتضغط يمين → «اسأل Soal.help عن النص المحدد».
- 🔒 المفتاح **محلي فقط** — بيتخزن في `chrome.storage.local`، مش على أي سيرفر خارجي.

## 🧪 التطوير / Development

الإضافة كلها JS خام — مفيش build step. غيّر أي ملف واضغط 🔄 Refresh في
`chrome://extensions` للتحميل من جديد.

- `manifest.json` — إعدادات MV3.
- `background.js` — Service worker (قائمة السياق + فتح الـ side panel).
- `sidebar.html/js` — واجهة الشات.
- `options.html/js` — صفحة الإعدادات.
- `styles.css` — CSS مشترك.
- `icons/` — أيقونات PNG.

## ⚠️ ملاحظات مهمة / Notes

- الإضافة بتشتغل مع **الإنتاج بس** (`https://soal.help/api/v1`). لو محتاج تغيّر
  الـ Base URL (مثلاً بريفيو) — من صفحة Options.
- Chrome بيتطلب أن الـ side panel يشتغل من نسخة **Chrome 114+** أو **Edge 114+**.
- لو الموديل بتاعك بيدعم Streaming (كل الموديلات على Soal.help بتدعمه)، الرد هيوصلك حرف حرف.
