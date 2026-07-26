#!/usr/bin/env bash
# Soal.help — Codex CLI installer for Linux / macOS

set -euo pipefail

if [ -r /dev/tty ]; then TTY=/dev/tty; else TTY=/dev/stdin; fi

GREEN=$'\033[92m'; YELLOW=$'\033[93m'; RED=$'\033[91m'; CYAN=$'\033[96m'; RESET=$'\033[0m'
info()  { echo -e "${CYAN}[i]${RESET} $*"; }
ok()    { echo -e "${GREEN}[✔]${RESET} $*"; }
warn()  { echo -e "${YELLOW}[!]${RESET} $*"; }
fail()  { echo -e "${RED}[✗]${RESET} $*" >&2; exit 1; }

# --- 1) Requirements ---
case "$(uname -s)" in
  Linux*|Darwin*) ;;
  *) fail "OS مش مدعوم: $(uname -s)" ;;
esac

if ! command -v node >/dev/null 2>&1; then
  fail "Node.js مش موجود. ثبّته الأول:
    - Ubuntu/Debian: sudo apt install nodejs npm
    - Fedora:        sudo dnf install nodejs npm
    - macOS:         brew install node"
fi
info "Node.js: $(node --version)"

# --- 2) Codex CLI ---
if command -v codex >/dev/null 2>&1; then
  ok "Codex مثبّت بالفعل: $(codex --version 2>/dev/null || echo '?')"
else
  info "بأثبّت @openai/codex (ممكن ياخد دقيقة)..."
  npm install -g @openai/codex || fail "فشل تثبيت codex"
  ok "اتثبّت: $(codex --version 2>/dev/null || echo ok)"
fi

# --- 3) Codex config dir ---
mkdir -p "$HOME/.codex"

# --- 4) API key ---
API_KEY_FILE="$HOME/.codex/.env"
EXISTING=""
if [ -f "$API_KEY_FILE" ]; then
  EXISTING=$(grep -Eo 'sk-[A-Za-z0-9_-]{20,}' "$API_KEY_FILE" 2>/dev/null | head -1)
fi

if [ -n "$EXISTING" ]; then
  ok "المفتاح موجود بالفعل (${EXISTING:0:8}...)"
  USER_KEY="$EXISTING"
else
  echo
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "  اطلع مفتاح API من: ${YELLOW}https://soal.help/app/keys${RESET}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo
  USER_KEY=""
  for attempt in 1 2 3; do
    read -rp "الصق مفتاح API: " RAW_KEY < "$TTY"
    CLEAN=$(printf '%s' "$RAW_KEY" | tr -d '\r\n\t ')
    if [[ "$CLEAN" =~ (sk-[A-Za-z0-9_-]{20,}) ]]; then
      USER_KEY="${BASH_REMATCH[1]}"
      ok "المفتاح اتقرا صح ✔"
      break
    fi
    warn "مفتاح غير صحيح (محاولة $attempt/3)"
  done
  [ -n "$USER_KEY" ] || fail "مفتاح مش صحيح"
  cat > "$API_KEY_FILE" <<EOF
export SOAL_API_KEY="$USER_KEY"
EOF
  chmod 600 "$API_KEY_FILE"
fi

# --- 5) Fetch config.toml + profiles + catalog ---
REPO_URL="${SOAL_INSTALL_REPO:-https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux}"
_src="${BASH_SOURCE[0]:-}"
if [ -n "$_src" ] && [ -f "$_src" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$_src")" 2>/dev/null && pwd || echo "/tmp")"
  TERMUX_DIR="$SCRIPT_DIR/../termux"
else
  SCRIPT_DIR="/tmp"
  TERMUX_DIR=""
fi

fetch() {
  local target="$1" remote="$2"
  if [ -n "$TERMUX_DIR" ] && [ -f "$TERMUX_DIR/$remote" ]; then
    cp "$TERMUX_DIR/$remote" "$target"
  else
    curl -fsSL "$REPO_URL/$remote" -o "$target" || fail "فشل تحميل: $remote"
  fi
}

# Backup old config if present
if [ -f "$HOME/.codex/config.toml" ]; then
  cp "$HOME/.codex/config.toml" "$HOME/.codex/config.toml.bak.$(date +%s)"
  warn "الـ config القديم اتنسخ backup"
fi

fetch "$HOME/.codex/config.toml" "config.toml"

# Adjust the Termux-specific trusted-project path to $HOME
sed -i.tmp "s|/data/data/com.termux/files/home|${HOME//\//\\/}|g" "$HOME/.codex/config.toml" 2>/dev/null || \
  sed -i '' "s|/data/data/com.termux/files/home|${HOME//\//\\/}|g" "$HOME/.codex/config.toml"
rm -f "$HOME/.codex/config.toml.tmp"

# Model catalog
fetch "$HOME/.codex/model_catalog.json" "model_catalog.json"
if ! grep -q 'model_catalog_json' "$HOME/.codex/config.toml"; then
  printf '\nmodel_catalog_json = "%s/.codex/model_catalog.json"\n' "$HOME" >> "$HOME/.codex/config.toml"
fi

# Profiles
PROFILES=(
  claude-haiku claude-sonnet claude-sonnet-46 claude-opus claude-opus-47 claude-fable
  gpt-mini gpt5 gpt54 gpt-4o gpt41-mini o3 o4-mini
  gemini-pro gemini-25-pro gemini-flash gemini-flash-3 gemini-25-flash
)
for p in "${PROFILES[@]}"; do
  fetch "$HOME/.codex/${p}.config.toml" "profiles/${p}.config.toml"
done
ok "الإعدادات + ${#PROFILES[@]} profile → $HOME/.codex/"

# --- 6) Load key into current shell ---
RC_FILE="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && RC_FILE="$HOME/.zshrc"
touch "$RC_FILE"
if ! grep -q '\.codex/\.env' "$RC_FILE" 2>/dev/null; then
  cat >> "$RC_FILE" <<'EOF'
if [ -f "$HOME/.codex/.env" ]; then
  __soal_key=$(grep -Eo 'sk-[A-Za-z0-9_-]{20,}' "$HOME/.codex/.env" 2>/dev/null | head -1)
  [ -n "$__soal_key" ] && export SOAL_API_KEY="$__soal_key"
  unset __soal_key
fi
EOF
fi
export SOAL_API_KEY="$USER_KEY"

echo
ok "التثبيت اكتمل!"
echo
echo -e "${CYAN}جرّب دلوقتي:${RESET}"
echo -e "  ${GREEN}source $RC_FILE${RESET}"
echo -e "  ${GREEN}codex${RESET}                                ← يفتح المحادثة"
echo -e "  ${GREEN}codex --profile claude-sonnet-46${RESET}     ← موديل معيّن"
echo -e "  ${GREEN}codex --profile gpt5 \"اكتب قصة قصيرة\"${RESET}"
echo
echo -e "الرصيد: ${CYAN}https://soal.help/app/dashboard${RESET}"
