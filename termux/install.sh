#!/usr/bin/env bash
# Soal.help — Termux Installer

set -euo pipefail

if [ -r /dev/tty ]; then TTY=/dev/tty; else TTY=/dev/stdin; fi

GREEN=$'\033[92m'; YELLOW=$'\033[93m'; RED=$'\033[91m'; CYAN=$'\033[96m'
BOLD=$'\033[1m';   RESET=$'\033[0m'

info()  { echo -e "${CYAN}[i]${RESET} $*"; }
ok()    { echo -e "${GREEN}[+]${RESET} $*"; }
warn()  { echo -e "${YELLOW}[!]${RESET} $*"; }
fail()  { echo -e "${RED}[x]${RESET} $*" >&2; exit 1; }
step()  { echo; echo -e "${CYAN}${BOLD}━━━ $* ━━━${RESET}"; }

# --- Language selection ---
clear
echo -e "${CYAN}${BOLD}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║        Soal.help — Termux Installer       ║"
echo "  ║        بوابة النماذج الاصطناعية           ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${RESET}"
echo "   1) 🇪🇬 العربية (Arabic)"
echo "   2) 🇬🇧 English"
echo
read -rp "  اختر اللغة / Choose language [1-2, default=1]: " LANG_CHOICE < "$TTY"
case "${LANG_CHOICE:-1}" in
  2|en|EN|e|E) LANG=en ;;
  *)          LANG=ar ;;
esac
echo

_t() {
  local k="$1"
  case "$LANG:$k" in
    "ar:s1")  echo "الخطوة 1 من 6 — الفحص المبدئي" ;;
    "en:s1")  echo "Step 1 of 6 — Initial check" ;;
    "ar:s2")  echo "الخطوة 2 من 6 — تثبيت الحزم الأساسية" ;;
    "en:s2")  echo "Step 2 of 6 — Installing base packages" ;;
    "ar:s3")  echo "الخطوة 3 من 6 — تثبيت Codex CLI" ;;
    "en:s3")  echo "Step 3 of 6 — Installing Codex CLI" ;;
    "ar:s4")  echo "الخطوة 4 من 6 — مفتاح API بتاع Soal.help" ;;
    "en:s4")  echo "Step 4 of 6 — Soal.help API Key" ;;
    "ar:s5")  echo "الخطوة 5 من 6 — ملف الإعدادات + الـ launcher" ;;
    "en:s5")  echo "Step 5 of 6 — Configuration & launcher" ;;
    "ar:s6")  echo "الخطوة 6 من 6 — تحديث إعدادات الـ shell" ;;
    "en:s6")  echo "Step 6 of 6 — Updating shell config" ;;

    "ar:not_termux") echo "شكل الجهاز ده مش Termux. هكمّل بس ممكن بعض الأمور ما تشتغلش صح." ;;
    "en:not_termux") echo "This doesn't look like Termux. Continuing, but some things may not work." ;;
    "ar:in_termux")  echo "تمام، إنت في Termux ✔" ;;
    "en:in_termux")  echo "Great — you're in Termux ✔" ;;

    "ar:updating") echo "بأحدّث الـ package list (ممكن ياخد دقيقة)..." ;;
    "en:updating") echo "Updating package list (may take a minute)..." ;;
    "ar:upd_fail") echo "فشل التحديث — هكمّل" ;;
    "en:upd_fail") echo "Update failed — continuing" ;;
    "ar:inst_node") echo "بأثبّت Node.js..." ;;
    "en:inst_node") echo "Installing Node.js..." ;;
    "ar:node_ok")   echo "اتثبّت Node.js" ;;
    "en:node_ok")   echo "Node.js installed" ;;
    "ar:node_have") echo "Node.js مثبّت بالفعل" ;;
    "en:node_have") echo "Node.js already installed" ;;
    "ar:node_fail") echo "فشل تثبيت Node.js" ;;
    "en:node_fail") echo "Failed to install Node.js" ;;
    "ar:inst_fzf")  echo "بأثبّت fzf (لاختيار الموديل بسرعة)..." ;;
    "en:inst_fzf")  echo "Installing fzf (for quick model picking)..." ;;
    "ar:fzf_fail")  echo "فشل تثبيت fzf — الـ launcher هيشتغل بدونه" ;;
    "en:fzf_fail")  echo "fzf install failed — launcher will still work without it" ;;
    "ar:fzf_have")  echo "fzf مثبّت بالفعل" ;;
    "en:fzf_have")  echo "fzf already installed" ;;

    "ar:codex_have") echo "Codex مثبّت بالفعل" ;;
    "en:codex_have") echo "Codex already installed" ;;
    "ar:inst_codex") echo "بأثبّت @mmmbuto/codex-cli-termux..." ;;
    "en:inst_codex") echo "Installing @mmmbuto/codex-cli-termux..." ;;
    "ar:inst_wait")  echo "الخطوة دي ممكن تاخد 2-5 دقايق — استنى." ;;
    "en:inst_wait")  echo "This may take 2-5 minutes — please wait." ;;
    "ar:codex_ok")   echo "اتثبّت Codex" ;;
    "en:codex_ok")   echo "Codex installed" ;;
    "ar:codex_fail") echo "فشل تثبيت Codex. جرّب يدوي: npm install -g @mmmbuto/codex-cli-termux@latest" ;;
    "en:codex_fail") echo "Codex install failed. Try manually: npm install -g @mmmbuto/codex-cli-termux@latest" ;;

    "ar:key_have")  echo "مفتاح API موجود بالفعل" ;;
    "en:key_have")  echo "API key already present" ;;
    "ar:key_intro") echo "عشان النظام يشتغل محتاج مفتاح API من حسابك على soal.help." ;;
    "en:key_intro") echo "You need an API key from your soal.help account." ;;
    "ar:key_steps") echo "الخطوات:" ;;
    "en:key_steps") echo "Steps:" ;;
    "ar:key_1") echo "1) افتح المتصفح على: https://soal.help/app/keys" ;;
    "en:key_1") echo "1) Open in browser: https://soal.help/app/keys" ;;
    "ar:key_2") echo "2) اضغط «إنشاء مفتاح جديد»" ;;
    "en:key_2") echo "2) Click «Create new key»" ;;
    "ar:key_3") echo "3) اعمل نسخ للمفتاح (شكله: sk-ac6f999...)" ;;
    "en:key_3") echo "3) Copy the key (format: sk-ac6f999...)" ;;
    "ar:key_4") echo "4) ارجع لهنا والصقه تحت" ;;
    "en:key_4") echo "4) Come back here and paste it below" ;;
    "ar:key_note") echo "💡 المفتاح هيظهر لك على الشاشة عشان تتأكد إن اللصق سليم." ;;
    "en:key_note") echo "💡 The key will be shown on-screen so you can verify the paste." ;;
    "ar:key_prompt")  echo "الصق مفتاح API واضغط Enter: " ;;
    "en:key_prompt")  echo "Paste API key and press Enter: " ;;
    "ar:key_ok")  echo "المفتاح اتقرا صح ✔" ;;
    "en:key_ok")  echo "Key read successfully ✔" ;;
    "ar:key_bad")   echo "معرفتش ألاقي مفتاح صحيح جوّه اللي لصقته." ;;
    "en:key_bad")   echo "Couldn't find a valid key in what you pasted." ;;
    "ar:key_got")   echo "اللي وصلني" ;;
    "en:key_got")   echo "Received" ;;
    "ar:key_hint")  echo "لازم يبدأ بـ sk- ويبقى بعده حروف/أرقام." ;;
    "en:key_hint")  echo "Must start with sk- followed by letters/digits." ;;
    "ar:key_ex")    echo "مثال شكله:" ;;
    "en:key_ex")    echo "Example format:" ;;
    "ar:key_try")   echo "حاول تاني (محاولة" ;;
    "en:key_try")   echo "Try again (attempt" ;;
    "ar:key_saved") echo "المفتاح اتحفظ في" ;;
    "en:key_saved") echo "Key saved to" ;;
    "ar:key_skip")  echo "معرفتش أقرأ مفتاح — هكمّل التثبيت. لما تجيب المفتاح، شغّل الـ installer تاني." ;;
    "en:key_skip")  echo "Couldn't read a key — continuing install. Re-run installer once you have the key." ;;

    "ar:cfg_bak") echo "الـ config القديم اتنقل لملف backup" ;;
    "en:cfg_bak") echo "Old config backed up" ;;
    "ar:cfg_ok")  echo "الإعدادات →" ;;
    "en:cfg_ok")  echo "Config →" ;;
    "ar:lnc_ok")  echo "الـ launcher →" ;;
    "en:lnc_ok")  echo "Launcher →" ;;

    "ar:rc_ok") echo "الـ shell اتحدّث في" ;;
    "en:rc_ok") echo "Shell config updated at" ;;

    "ar:done")     echo "✔✔✔ التثبيت خلص بنجاح! ✔✔✔" ;;
    "en:done")     echo "✔✔✔ Installation complete! ✔✔✔" ;;
    "ar:try_now")  echo "جرّب دلوقتي:" ;;
    "en:try_now")  echo "Try now:" ;;
    "ar:hint1")    echo "قائمة اختيار الموديل" ;;
    "en:hint1")    echo "model picker menu" ;;
    "ar:hint2")    echo "يشتغل مباشرة على Claude Opus" ;;
    "en:hint2")    echo "run directly on Claude Opus" ;;
    "ar:hint3")    echo "يشتغل + سؤال" ;;
    "en:hint3")    echo "run + prompt" ;;
    "ar:reload")   echo "ملحوظة: لو أول مرة، شغّل الأمر ده مرة واحدة:" ;;
    "en:reload")   echo "Note: first-time only, run this once:" ;;
    "ar:balance")  echo "الرصيد بتاعك في:" ;;
    "en:balance")  echo "Your balance:" ;;
    *) echo "$k" ;;
  esac
}

t() { _t "$1"; }

REPO_URL="${SOAL_INSTALL_REPO:-https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux}"

_src="${BASH_SOURCE[0]:-}"
if [ -n "$_src" ] && [ -f "$_src" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$_src")" 2>/dev/null && pwd || echo "/tmp")"
else
  SCRIPT_DIR="/tmp"
fi
unset _src

fetch() {
  local target="$1" remote="$2"
  if [ -f "$SCRIPT_DIR/$remote" ]; then
    cp "$SCRIPT_DIR/$remote" "$target"
  else
    curl -fsSL "$REPO_URL/$remote" -o "$target" || fail "download failed: $remote"
  fi
}

# --- 1) Termux check ---
step "$(t s1)"
if [ ! -d "/data/data/com.termux" ]; then
  warn "$(t not_termux)"
else
  ok "$(t in_termux)"
fi

# --- 2) Base packages ---
step "$(t s2)"
info "$(t updating)"
pkg update -y >/dev/null 2>&1 || warn "$(t upd_fail)"

if ! command -v node >/dev/null 2>&1; then
  info "$(t inst_node)"
  pkg install -y nodejs-lts || fail "$(t node_fail)"
  ok "$(t node_ok): $(node --version)"
else
  ok "$(t node_have): $(node --version)"
fi

if ! command -v fzf >/dev/null 2>&1; then
  info "$(t inst_fzf)"
  pkg install -y fzf || warn "$(t fzf_fail)"
else
  ok "$(t fzf_have)"
fi

# --- 3) Codex CLI ---
step "$(t s3)"
if command -v codex >/dev/null 2>&1; then
  ok "$(t codex_have): $(codex --version 2>/dev/null || echo '?')"
else
  info "$(t inst_codex)"
  info "$(t inst_wait)"
  npm install -g @mmmbuto/codex-cli-termux@latest || fail "$(t codex_fail)"
  ok "$(t codex_ok): $(codex --version 2>/dev/null || echo 'ok')"
fi

# --- 4) API key ---
step "$(t s4)"
mkdir -p "$HOME/.codex"
API_KEY_FILE="$HOME/.codex/.env"
NEEDS_MANUAL_KEY=""

EXISTING_KEY=""
if [ -f "$API_KEY_FILE" ]; then
  EXISTING_KEY=$(grep -Eo 'sk-[A-Fa-f0-9]{40,64}' "$API_KEY_FILE" 2>/dev/null | head -1)
  [ -z "$EXISTING_KEY" ] && \
    EXISTING_KEY=$(grep -Eo 'sk-[A-Za-z0-9_-]{20,}' "$API_KEY_FILE" 2>/dev/null | head -1)
fi

if [ -n "$EXISTING_KEY" ]; then
  cat > "$API_KEY_FILE" <<EOF
export SOAL_API_KEY="$EXISTING_KEY"
EOF
  chmod 600 "$API_KEY_FILE"
  ok "$(t key_have) (${EXISTING_KEY:0:8}...)"
else
  echo
  echo -e "${YELLOW}$(t key_intro)${RESET}"
  echo
  echo -e "  ${BOLD}$(t key_steps)${RESET}"
  echo -e "  $(t key_1 | sed 's|https://[^ ]*|'"${CYAN}&${RESET}"'|')"
  echo -e "  $(t key_2)"
  echo -e "  $(t key_3)"
  echo -e "  $(t key_4)"
  echo
  echo -e "  ${YELLOW}$(t key_note)${RESET}"
  echo

  USER_KEY=""
  for attempt in 1 2 3; do
    read -rp "$(t key_prompt)" RAW_KEY < "$TTY"
    CLEAN=$(printf '%s' "$RAW_KEY" | tr -d '\r\n\t ')
    if [[ "$CLEAN" =~ (sk-[A-Fa-f0-9]{40,64}) ]]; then
      USER_KEY="${BASH_REMATCH[1]}"
      ok "$(t key_ok) (${USER_KEY:0:8}... - ${#USER_KEY})"
      break
    elif [[ "$CLEAN" =~ (sk-[A-Za-z0-9_-]{20,}) ]]; then
      USER_KEY="${BASH_REMATCH[1]}"
      ok "$(t key_ok) (${USER_KEY:0:8}... - ${#USER_KEY})"
      break
    fi
    warn "$(t key_bad)"
    warn "$(t key_got) (${#CLEAN}): ${CLEAN:0:30}..."
    warn "$(t key_hint)"
    echo -e "${CYAN}$(t key_ex)${RESET} sk-ac6f999cfff0b053d3c46779f4e45252353acfdfa6910532"
    echo -e "${YELLOW}$(t key_try) $attempt/3)${RESET}"
    USER_KEY=""
  done

  if [ -n "$USER_KEY" ]; then
    cat > "$API_KEY_FILE" <<EOF
export SOAL_API_KEY="$USER_KEY"
EOF
    chmod 600 "$API_KEY_FILE"
    ok "$(t key_saved) $API_KEY_FILE"
  else
    warn "$(t key_skip)"
    if [ ! -f "$API_KEY_FILE" ] || ! grep -Eq 'sk-[A-Za-z0-9_-]{20,}' "$API_KEY_FILE" 2>/dev/null; then
      printf 'export SOAL_API_KEY=""\n' > "$API_KEY_FILE"
      chmod 600 "$API_KEY_FILE"
    fi
    NEEDS_MANUAL_KEY=1
  fi
fi

# --- 5) Config + launcher ---
step "$(t s5)"
if [ -f "$HOME/.codex/config.toml" ]; then
  cp "$HOME/.codex/config.toml" "$HOME/.codex/config.toml.bak.$(date +%s)"
  warn "$(t cfg_bak)"
fi
fetch "$HOME/.codex/config.toml" "config.toml"

# Model catalog — يشيل تحذير "Model metadata not found"
fetch "$HOME/.codex/model_catalog.json" "model_catalog.json"
if ! grep -q 'model_catalog_json' "$HOME/.codex/config.toml"; then
  printf '\nmodel_catalog_json = "%s/.codex/model_catalog.json"\n' "$HOME" >> "$HOME/.codex/config.toml"
fi
ok "$(t cfg_ok) $HOME/.codex/config.toml"

PROFILES=(
  claude-haiku claude-sonnet claude-sonnet-46 claude-opus claude-opus-47 claude-fable
  gpt-mini gpt5 gpt54 gpt-4o gpt41-mini o3 o4-mini
  gemini-pro gemini-25-pro gemini-flash gemini-flash-3 gemini-25-flash
)
for p in "${PROFILES[@]}"; do
  fetch "$HOME/.codex/${p}.config.toml" "profiles/${p}.config.toml"
done
ok "profiles → $HOME/.codex/*.config.toml (${#PROFILES[@]} files)"

mkdir -p "$HOME/bin"

BIN_DIR="$HOME/bin"
PREFIX_BIN=""
if [ -n "${PREFIX:-}" ] && [ -d "${PREFIX}/bin" ] && [ -w "${PREFIX}/bin" ]; then
  PREFIX_BIN="${PREFIX}/bin"
fi

fetch "$HOME/bin/soal" "soal"
chmod +x "$HOME/bin/soal"

if [ -n "$PREFIX_BIN" ]; then
  cp "$HOME/bin/soal" "$PREFIX_BIN/soal" 2>/dev/null && chmod +x "$PREFIX_BIN/soal" 2>/dev/null || true
  ok "$(t lnc_ok) $PREFIX_BIN/soal"
else
  ok "$(t lnc_ok) $HOME/bin/soal"
fi

# --- 6) Shell rc ---
step "$(t s6)"
NEEDS_RELOAD=""
RC_FILE="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && RC_FILE="$HOME/.zshrc"
touch "$RC_FILE"

if [ -z "$PREFIX_BIN" ] && ! grep -q 'HOME/bin' "$RC_FILE" 2>/dev/null; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$RC_FILE"
  NEEDS_RELOAD=1
fi

if ! grep -q '\.codex/\.env' "$RC_FILE" 2>/dev/null; then
  cat >> "$RC_FILE" <<'EOF'
if [ -f "$HOME/.codex/.env" ]; then
  __soal_key=$(grep -Eo 'sk-[A-Za-z0-9_-]{20,}' "$HOME/.codex/.env" 2>/dev/null | head -1)
  [ -n "$__soal_key" ] && export SOAL_API_KEY="$__soal_key"
  unset __soal_key
fi
EOF
  NEEDS_RELOAD=1
fi

export PATH="$HOME/bin:$PATH"
__soal_key=$(grep -Eo 'sk-[A-Za-z0-9_-]{20,}' "$HOME/.codex/.env" 2>/dev/null | head -1)
[ -n "$__soal_key" ] && export SOAL_API_KEY="$__soal_key"
unset __soal_key

ok "$(t rc_ok) $RC_FILE"

echo
echo -e "${GREEN}${BOLD}$(t done)${RESET}"
echo
echo -e "${BOLD}$(t try_now)${RESET}"
echo -e "  ${CYAN}soal${RESET}                          ← $(t hint1)"
echo -e "  ${CYAN}soal claude-opus${RESET}              ← $(t hint2)"
if [ "$LANG" = "ar" ]; then
  echo -e "  ${CYAN}soal gpt5 \"إزيك؟\"${RESET}            ← $(t hint3)"
else
  echo -e "  ${CYAN}soal gpt5 \"hi there\"${RESET}         ← $(t hint3)"
fi
echo

if [ -z "$PREFIX_BIN" ] && [ -n "$NEEDS_RELOAD" ]; then
  echo -e "${YELLOW}$(t reload)${RESET}"
  echo -e "  ${CYAN}source $RC_FILE${RESET}"
  if [ "$LANG" = "ar" ]; then
    echo -e "  ${YELLOW}أو اقفل الترمنال وافتحه تاني.${RESET}"
  else
    echo -e "  ${YELLOW}or close and reopen your terminal.${RESET}"
  fi
  echo
fi

hash -r 2>/dev/null || true

echo -e "${BOLD}$(t balance)${RESET} ${CYAN}https://soal.help/app/dashboard${RESET}"
echo
