/**
 * Soal.help — Node.js example using the Responses API.
 *
 * The Responses API is OpenAI's newer alternative to Chat Completions. Codex
 * CLI 0.145+, the newer OpenAI Agents SDK and Continue.dev (recent versions)
 * all default to it. Soal.help supports both endpoints — `/v1/chat/completions`
 * and `/v1/responses` — so you can pick whichever your tooling prefers.
 *
 *   npm install openai
 *   export SOAL_API_KEY=sk-...
 *   node nodejs-responses.js
 */

import OpenAI from 'openai';

const client = new OpenAI({
  apiKey: process.env.SOAL_API_KEY,
  baseURL: 'https://soal.help/api/v1',
});

// ---- 1) Non-streaming ----
console.log('--- Non-streaming ---');
const resp = await client.responses.create({
  model: 'claude-haiku-4-5-20251001',
  input: 'قوللي معلومة عن الأهرامات في 3 نقط.',
  instructions: 'أجب باللغة العربية.',
  max_output_tokens: 200,
});
console.log(resp.output_text);
console.log();

// ---- 2) Streaming ----
console.log('--- Streaming ---');
const stream = await client.responses.create({
  model: 'claude-haiku-4-5-20251001',
  input: 'اكتب قصيدة قصيرة عن القاهرة.',
  stream: true,
});
for await (const event of stream) {
  if (event.type === 'response.output_text.delta') {
    process.stdout.write(event.delta);
  }
}
console.log();

// ---- 3) Function calling (tool use) ----
console.log('\n--- Function calling ---');
const withTool = await client.responses.create({
  model: 'claude-haiku-4-5-20251001',
  input: 'إيه الجو في القاهرة النهاردة؟',
  tools: [{
    type: 'function',
    name: 'get_weather',
    description: 'احصل على درجة الحرارة الحالية لمدينة',
    parameters: {
      type: 'object',
      properties: {
        city: { type: 'string', description: 'اسم المدينة' },
      },
      required: ['city'],
    },
  }],
  tool_choice: 'auto',
});
for (const item of withTool.output) {
  if (item.type === 'function_call') {
    console.log(`  tool called: ${item.name}(${item.arguments})`);
  } else if (item.type === 'message') {
    for (const c of item.content) {
      if (c.type === 'output_text') console.log(`  text: ${c.text}`);
    }
  }
}
