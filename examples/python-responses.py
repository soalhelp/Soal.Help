"""Soal.help — Python (openai SDK) example using the Responses API.

The Responses API is OpenAI's newer alternative to Chat Completions. Codex
CLI 0.145+, the newer OpenAI Agents SDK and Continue.dev (recent versions)
all default to it. Soal.help supports both endpoints — `/v1/chat/completions`
and `/v1/responses` — so you can pick whichever your tooling prefers.

Install and run:

    pip install openai
    export SOAL_API_KEY=sk-...
    python python-responses.py
"""

import os
from openai import OpenAI

client = OpenAI(
    api_key=os.environ["SOAL_API_KEY"],
    base_url="https://soal.help/api/v1",
)

# ---- 1) Non-streaming ----
print("--- Non-streaming ---")
resp = client.responses.create(
    model="claude-haiku-4-5-20251001",
    input="قوللي معلومة عن الأهرامات في 3 نقط.",
    instructions="أجب باللغة العربية.",
    max_output_tokens=200,
)
print(resp.output_text)
print()

# ---- 2) Streaming ----
print("--- Streaming ---")
stream = client.responses.create(
    model="claude-haiku-4-5-20251001",
    input="اكتب قصيدة قصيرة عن القاهرة.",
    stream=True,
)
for event in stream:
    # Text deltas come as `response.output_text.delta` events.
    if getattr(event, "type", "") == "response.output_text.delta":
        print(event.delta, end="", flush=True)
print()

# ---- 3) Function calling (tool use) ----
print("\n--- Function calling ---")
resp = client.responses.create(
    model="claude-haiku-4-5-20251001",
    input="إيه الجو في القاهرة النهاردة؟",
    tools=[{
        "type": "function",
        "name": "get_weather",
        "description": "احصل على درجة الحرارة الحالية لمدينة",
        "parameters": {
            "type": "object",
            "properties": {
                "city": {"type": "string", "description": "اسم المدينة"},
            },
            "required": ["city"],
        },
    }],
    tool_choice="auto",
)
for item in resp.output:
    if item.type == "function_call":
        print(f"  tool called: {item.name}({item.arguments})")
    elif item.type == "message":
        for c in item.content:
            if c.type == "output_text":
                print(f"  text: {c.text}")
