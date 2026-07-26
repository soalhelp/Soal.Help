#!/usr/bin/env bash
# Soal.help — Doctor (فحص فقط، مبيغيّرش أي حاجة)

set +e

GREEN=$'\033[92m'; YELLOW=$'\033[93m'; RED=$'\033[91m'
CYAN=$'\033[96m'; BOLD=$'\033[1m'; RESET=$'\033[0m'

check_ok()   { echo -e "  ${GREEN}[✓]${RESET} $*"; }
check_bad()  { echo -e "  ${RED}[✗]${RESET} $*"; }
check_warn() { echo -e "  ${YELLOW}[!]${RESET} $*"; }
header()     { echo; echo -e "${CYAN}${BOLD}━━━ $* ━━━${RESET}"; }

echo -e "${CYAN}${BOLD}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║        Soal.help — System Doctor         ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${RESET}"

header "1) الأدوات الأساسية"

if command -v node >/dev/null 2>&1; then
  check_ok "Node.js: $(node --version)"
else
  check_bad "Node.js مش موجود — pkg install nodejs-lts"
fi

if command -v npm >/dev/null 2>&1; then
  check_ok "npm: $(npm --version)"
else
  check_bad "npm مش موجود"
fi

if command -v codex >/dev/null 2>&1; then
  CODEX_VER=$(codex --version 2>&1 | head -1)
  check_ok "Codex CLI: $CODEX_VER"
else
  check_bad "Codex مش موجود — npm install -g @mmmbuto/codex-cli-termux@latest"
fi

if command -v fzf >/dev/null 2>&1; then
  check_ok "fzf: $(fzf --version | awk '{print $1}')"
else
  check_warn "fzf مش موجود (اختياري) — pkg install fzf"
fi

header "2) ملفات الإعداد"

if [ -d "$HOME/.codex" ]; then
  check_ok "المجلد ~/.codex موجود"
  ls -la "$HOME/.codex/" 2>/dev/null | grep -v '^total' | sed 's/^/     /'
else
  check_bad "~/.codex مش موجود — شغّل install.sh"
fi

echo
if [ -f "$HOME/.codex/config.toml" ]; then
  check_ok "config.toml موجود ($(wc -l < "$HOME/.codex/config.toml") سطر)"
  LEGACY=$(grep -cE '^profile\s*=|^\[profiles\.' "$HOME/.codex/config.toml" 2>/dev/null)
  if [ "${LEGACY:-0}" -gt 0 ]; then
    check_bad "فيه $LEGACY سطر legacy في config.toml"
    check_warn "الحل: أعد تشغيل install.sh"
  else
    check_ok "config.toml نضيف ✓"
  fi
  if grep -q '\[model_providers\.soal\]' "$HOME/.codex/config.toml"; then
    check_ok "المزوّد soal معرّف"
  else
    check_bad "المزوّد soal مش معرّف!"
  fi
else
  check_bad "config.toml مش موجود"
fi

echo
if [ -f "$HOME/.codex/.env" ]; then
  check_ok ".env موجود (صلاحيات: $(stat -c '%a' "$HOME/.codex/.env" 2>/dev/null || stat -f '%OLp' "$HOME/.codex/.env" 2>/dev/null))"
  KEY=$(grep -Eo 'sk-[A-Za-z0-9_-]{20,}' "$HOME/.codex/.env" 2>/dev/null | head -1)
  if [ -n "$KEY" ]; then
    check_ok "المفتاح موجود (${KEY:0:8}...${KEY: -4}) - طول: ${#KEY}"
  else
    check_bad "مفيش مفتاح في .env — شغّل install.sh"
  fi
else
  check_bad ".env مش موجود"
fi

header "3) الـ Launcher"

if [ -f "$HOME/bin/soal" ]; then
  if [ -x "$HOME/bin/soal" ]; then
    check_ok "~/bin/soal موجود وقابل للتشغيل"
    MODELS=$(grep -oE '"[a-z-]+\|[a-z0-9.-]+\|' "$HOME/bin/soal" 2>/dev/null | wc -l)
    check_ok "بيدعم $MODELS موديل"
  else
    check_warn "~/bin/soal موجود لكن مش قابل للتشغيل — chmod +x ~/bin/soal"
  fi
else
  check_bad "~/bin/soal مش موجود"
fi

if echo "$PATH" | tr ':' '\n' | grep -q "$HOME/bin"; then
  check_ok "~/bin في الـ PATH"
else
  check_warn "~/bin مش في الـ PATH — أضف: export PATH=\"\$HOME/bin:\$PATH\""
fi

header "4) الاتصال بـ Soal.help"

if [ -n "${KEY:-}" ]; then
  echo -n "  بأجرّب الاتصال..."
  RESP=$(curl -sS -m 10 -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $KEY" \
    https://soal.help/api/v1/models 2>&1)
  echo
  case "$RESP" in
    200) check_ok "الاتصال شغال (HTTP 200)" ;;
    401) check_bad "المفتاح غير صحيح أو منتهي (HTTP 401)" ;;
    402) check_warn "الرصيد خلص (HTTP 402) — اشحن من soal.help/app/topup" ;;
    000) check_warn "مفيش اتصال إنترنت — اتأكد" ;;
    *) check_warn "HTTP $RESP — استجابة غير متوقعة" ;;
  esac
else
  check_warn "متقدرش أفحص الاتصال — المفتاح مش موجود"
fi

header "5) ~/.bashrc أو ~/.zshrc"

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$rc" ] || continue
  echo -e "  ${BOLD}$rc:${RESET}"
  if grep -q 'HOME/bin' "$rc" 2>/dev/null; then
    check_ok "PATH بيتحدث ✓"
  else
    check_warn "PATH مش بيتحدث في $rc"
  fi
  if grep -q '\.codex/\.env' "$rc" 2>/dev/null; then
    check_ok "المفتاح بيتلقّم من .env ✓"
  else
    check_warn "المفتاح مش بيتلقّم من .env تلقائيًا"
  fi
done

echo
echo -e "${CYAN}════════════════════════════════════════${RESET}"
echo -e "${BOLD}الملخص:${RESET}"
echo -e "  لو كل الفحوصات فوق ${GREEN}[✓]${RESET}، جرّب: ${CYAN}soal --list${RESET}"
echo -e "  لو فيه ${RED}[✗]${RESET}، اتبع نصايح الإصلاح جنب كل فحص."
echo
