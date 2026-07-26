#!/usr/bin/env bash
# Soal.help — أمثلة curl على /v1/chat/completions و /v1/images/generations

BASE_URL="https://soal.help/api/v1"
API_KEY="sk-YOUR_KEY_HERE"

echo "--- 1) شات (non-stream) ---"
curl -s -X POST "$BASE_URL/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-haiku-4-5-20251001",
    "messages": [
      {"role": "user", "content": "قوللي معلومة عن الأهرامات في 3 نقط."}
    ]
  }' | jq

echo
echo "--- 2) شات (SSE stream) ---"
curl -N -X POST "$BASE_URL/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-haiku-4-5-20251001",
    "stream": true,
    "messages": [
      {"role": "user", "content": "اكتب قصيدة قصيرة عن القاهرة."}
    ]
  }'

echo
echo "--- 3) توليد صورة ---"
curl -s -X POST "$BASE_URL/images/generations" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-3.1-flash-image-preview",
    "prompt": "قطة برتقالية في مقهى بالقاهرة، ضوء طبيعي، تصوير سينمائي",
    "n": 1
  }' | jq
