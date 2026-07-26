"""Soal.help — Python (openai SDK) example.

$ pip install openai
$ export SOAL_API_KEY=sk-...
$ python python-openai.py
"""

import os
from openai import OpenAI

client = OpenAI(
    api_key=os.environ["SOAL_API_KEY"],
    base_url="https://soal.help/api/v1",
)

# ---- 1) Chat عادي ----
print("--- شات عادي ---")
resp = client.chat.completions.create(
    model="claude-haiku-4-5-20251001",
    messages=[
        {"role": "user", "content": "قوللي معلومة عن الأهرامات في 3 نقط."},
    ],
)
print(resp.choices[0].message.content)
print()

# ---- 2) Streaming ----
print("--- ستريمنج ---")
stream = client.chat.completions.create(
    model="claude-haiku-4-5-20251001",
    messages=[{"role": "user", "content": "اكتب قصيدة قصيرة عن القاهرة."}],
    stream=True,
)
for chunk in stream:
    delta = chunk.choices[0].delta.content
    if delta:
        print(delta, end="", flush=True)
print()

# ---- 3) توليد صورة ----
print("\n--- صورة ---")
img = client.images.generate(
    model="gemini-3.1-flash-image-preview",
    prompt="قطة برتقالية في مقهى بالقاهرة، ضوء طبيعي",
    n=1,
)
print("URL:", img.data[0].url)
