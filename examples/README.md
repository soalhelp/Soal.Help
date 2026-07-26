# 💻 Examples — Soal.help API

أمثلة كاملة على استخدام الـ API بلغات مختلفة.

## الملفات

| ملف                  | اللغة       | الطريقة |
|----------------------|-------------|---------|
| [`curl.sh`](curl.sh) | Bash + curl | نداءات API مباشرة |
| [`python-openai.py`](python-openai.py) | Python | Official `openai` SDK |
| [`nodejs-openai.js`](nodejs-openai.js) | Node.js | Official `openai` SDK |

## التشغيل

استبدل `sk-YOUR_KEY_HERE` بمفتاحك من [soal.help/app/keys](https://soal.help/app/keys).

### curl
```bash
bash curl.sh
```

### Python
```bash
pip install openai
export SOAL_API_KEY=sk-...
python python-openai.py
```

### Node.js
```bash
npm install openai
export SOAL_API_KEY=sk-...
node nodejs-openai.js
```

## النقاط الأساسية للاستخدام

الـ API متوافق **100% مع OpenAI SDK** — كل اللي تعمله:

1. غيّر `base_url` (Python) أو `baseURL` (Node) إلى `https://soal.help/api/v1`.
2. استخدم مفتاح `sk-...` بتاعك بدل مفتاح OpenAI.
3. **أسماء الموديلات مختلفة** — بدل `gpt-4` استخدم اسم الموديل الفعلي من [القايمة](https://soal.help/api/models).

## الـ Endpoints المدعومة

| Endpoint                        | الوظيفة |
|---------------------------------|---------|
| `POST /v1/chat/completions`     | شات كلاسيكي (streaming + non-streaming) |
| `POST /v1/responses`            | Responses API (Codex CLI ≥ 0.145، OpenAI Agents SDK) |
| `POST /v1/images/generations`   | توليد صور |
| `POST /v1/videos/generations`   | توليد فيديو (Sora 2) |
| `GET  /v1/models`               | قايمة الموديلات المتاحة |

## Response بيرجع رصيدك

كل رد ناجح فيه field إضافي اسمه `x_billing`:
```json
{
  "id": "chatcmpl-...",
  "choices": [...],
  "usage": {...},
  "x_billing": {
    "cost_egp": 0.0712,
    "balance_after_egp": 99.4288
  }
}
```
تقدر تعرض ده لليوزر بتاعك.

## معالجة الأخطاء

| Status | المعنى |
|--------|---------|
| `200`  | نجح |
| `400`  | مشكلة في الـ prompt (محتوى ممنوع، حجم كبير، إلخ) |
| `401`  | مفتاح API غير صحيح |
| `402`  | رصيد غير كافٍ — اشحن من [soal.help/app/topup](https://soal.help/app/topup) |
| `429`  | كتير طلبات مرة واحدة — استنى شويّة |
| `504`  | المزوّد تأخّر — حاول تاني |

الخطأ بيرجع بصيغة OpenAI القياسية:
```json
{ "error": { "message": "...", "type": "insufficient_quota", "code": "..." } }
```

  "id": "chatcmpl-...",
  "choices": [...],
  "usage": {...},
  "x_billing": {
    "cost_egp": 0.0712,
    "balance_after_egp": 99.4288
  }
}
```
تقدر تعرض ده لليوزر بتاعك.

## معالجة الأخطاء

| Status | المعنى |
|--------|---------|
| `200`  | نجح |
| `400`  | مشكلة في الـ prompt (محتوى ممنوع، حجم كبير، إلخ) |
| `401`  | مفتاح API غير صحيح |
| `402`  | رصيد غير كافٍ — اشحن من [soal.help/app/topup](https://soal.help/app/topup) |
| `429`  | كتير طلبات مرة واحدة — استنى شويّة |
| `504`  | المزوّد تأخّر — حاول تاني |

الخطأ بيرجع بصيغة OpenAI القياسية:
```json
{ "error": { "message": "...", "type": "insufficient_quota", "code": "..." } }
```
