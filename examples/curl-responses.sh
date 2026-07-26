#!/usr/bin/env bash
# Soal.help — أمثلة curl على /v1/responses

BASE_URL="https://soal.help/api/v1"
API_KEY="sk-YOUR_KEY_HERE"

echo "--- 1) Non-streaming ---"
curl -s -X POST "$BASE_URL/responses" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-haiku-4-5-20251001",
    "input": "قوللي معلومة عن الأهرامات في 3 نقط.",
    "instructions": "أجب باللغة العربية.",
    "max_output_tokens": 200
  }' | jq

echo
echo "--- 2) Streaming (SSE) ---"
curl -N -X POST "$BASE_URL/responses" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-haiku-4-5-20251001",
    "input": "اكتب قصيدة قصيرة عن القاهرة.",
    "stream": true
  }'

echo
echo "--- 3) Function calling ---"
curl -s -X POST "$BASE_URL/responses" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-haiku-4-5-20251001",
    "input": "إيه الجو في القاهرة النهاردة؟",
    "tools": [{
      "type": "function",
      "name": "get_weather",
      "description": "احصل على درجة الحرارة الحالية لمدينة",
      "parameters": {
        "type": "object",
        "properties": {
          "city": {"type": "string", "description": "اسم المدينة"}
        },
        "required": ["city"]
      }
    }],
    "tool_choice": "auto"
  }' | jq
