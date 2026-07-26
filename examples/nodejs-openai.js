/**
 * Soal.help — Node.js (openai SDK) example.
 *
 *   npm install openai
 *   export SOAL_API_KEY=sk-...
 *   node nodejs-openai.js
 */

import OpenAI from 'openai';

const client = new OpenAI({
  apiKey: process.env.SOAL_API_KEY,
  baseURL: 'https://soal.help/api/v1',
});

// ---- 1) Chat عادي ----
console.log('--- شات عادي ---');
const resp = await client.chat.completions.create({
  model: 'claude-haiku-4-5-20251001',
  messages: [{ role: 'user', content: 'قوللي معلومة عن الأهرامات في 3 نقط.' }],
});
console.log(resp.choices[0].message.content);
console.log();

// ---- 2) Streaming ----
console.log('--- ستريمنج ---');
const stream = await client.chat.completions.create({
  model: 'claude-haiku-4-5-20251001',
  messages: [{ role: 'user', content: 'اكتب قصيدة قصيرة عن القاهرة.' }],
  stream: true,
});
for await (const chunk of stream) {
  process.stdout.write(chunk.choices[0]?.delta?.content ?? '');
}
console.log();

// ---- 3) توليد صورة ----
console.log('\n--- صورة ---');
const img = await client.images.generate({
  model: 'gemini-3.1-flash-image-preview',
  prompt: 'قطة برتقالية في مقهى بالقاهرة، ضوء طبيعي',
  n: 1,
});
console.log('URL:', img.data[0].url);
