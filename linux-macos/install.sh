#!/usr/bin/env bash
# Soal.help — Linux / macOS installer
# curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/linux-macos/install.sh | bash

set -euo pipefail

if [ -r /dev/tty ]; then TTY=/dev/tty; else TTY=/dev/stdin; fi

GREEN=$'\033[92m'; YELLOW=$'\033[93m'; RED=$'\033[91m'; CYAN=$'\033[96m'; RESET=$'\033[0m'
info()  { echo -e "${CYAN}[i]${RESET} $*"; }
ok()    { echo -e "${GREEN}[✔]${RESET} $*"; }
warn()  { echo -e "${YELLOW}[!]${RESET} $*"; }
fail()  { echo -e "${RED}[✗]${RESET} $*" >&2; exit 1; }

# --- 1) Detect OS + arch ---
case "$(uname -s)" in
  Linux*)  OS="linux" ;;
  Darwin*) OS="mac" ;;
  *)       fail "OS مش مدعوم: $(uname -s). استخدم termux/ أو windows/ بدل ده." ;;
esac
case "$(uname -m)" in
  x86_64|amd64)         ARCH="x86_64" ;;
  aarch64|arm64)        ARCH="aarch64" ;;
  armv7l|armv7)         ARCH="armv7" ;;
  *)                    fail "المعالج مش مدعوم: $(uname -m)" ;;
esac
info "النظام: $OS / $ARCH"

# --- 2) Install aichat ---
install_aichat_binary() {
  info "بأنزّل aichat من GitHub Releases..."
  local target
  if [ "$OS" = "mac" ]; then
    case "$ARCH" in
      x86_64)   target="x86_64-apple-darwin" ;;
      aarch64)  target="aarch64-apple-darwin" ;;
      *)        fail "معمارية مش مدعومة لـ ماك: $ARCH" ;;
    esac
  else
    case "$ARCH" in
      x86_64)   target="x86_64-unknown-linux-musl" ;;
      aarch64)  target="aarch64-unknown-linux-musl" ;;
      armv7)    target="armv7-unknown-linux-musleabihf" ;;
      *)        fail "معمارية مش مدعومة لـ لينكس: $ARCH" ;;
    esac
  fi

  local api="https://api.github.com/repos/sigoden/aichat/releases/latest"
  local url
  url=$(curl -fsSL "$api" 2>/dev/null | grep -Eo "\"browser_download_url\": *\"[^\"]*${target}\.tar\.gz\"" | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
  [ -n "$url" ] || fail "معرفتش أجيب لينك التحميل من GitHub"

  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/aichat.tar.gz" || fail "فشل التحميل: $url"
  tar -xzf "$tmp/aichat.tar.gz" -C "$tmp" || fail "فشل فك الضغط"

  local bin
  bin=$(find "$tmp" -maxdepth 3 -name aichat -type f | head -1)
  [ -n "$bin" ] || fail "مالقيتش ملف aichat في الأرشيف"

  mkdir -p "$HOME/.local/bin"
  install -m 755 "$bin" "$HOME/.local/bin/aichat"
  rm -rf "$tmp"

  if ! echo ":$PATH:" | grep -q ":$HOME/.local/bin:"; then
    export PATH="$HOME/.local/bin:$PATH"
    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
      [ -f "$rc" ] || continue
      grep -q '\.local/bin' "$rc" 2>/dev/null || \
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc"
    done
  fi
}

if command -v aichat >/dev/null 2>&1; then
  ok "aichat مثبّت بالفعل: $(aichat --version)"
else
  if [ "$OS" = "mac" ] && command -v brew >/dev/null 2>&1; then
    info "بأثبّت aichat عن طريق brew..."
    brew install aichat || install_aichat_binary
  else
    install_aichat_binary
  fi
  command -v aichat >/dev/null 2>&1 || fail "فشل تثبيت aichat"
  ok "اتثبّت aichat: $(aichat --version 2>/dev/null || echo ok)"
fi

# --- 3) aichat config location ---
if [ "$OS" = "mac" ]; then
  AICHAT_DIR="$HOME/Library/Application Support/aichat"
else
  AICHAT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/aichat"
fi
mkdir -p "$AICHAT_DIR"

# --- 4) API key ---
if [ -z "${SOAL_API_KEY:-}" ]; then
  echo
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "  اطلع مفتاح API من: ${YELLOW}https://soal.help/app/keys${RESET}"
  echo -e "  المفتاح شكله: ${YELLOW}sk-ac6f999...${RESET}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo
  for attempt in 1 2 3; do
    read -rp "الصق مفتاح API: " RAW_KEY < "$TTY"
    CLEAN=$(printf '%s' "$RAW_KEY" | tr -d '\r\n\t ')
    if [[ "$CLEAN" =~ (sk-[A-Fa-f0-9]{40,64}) ]]; then
      SOAL_API_KEY="${BASH_REMATCH[1]}"; ok "المفتاح اتقرا صح ✔"; break
    elif [[ "$CLEAN" =~ (sk-[A-Za-z0-9_-]{20,}) ]]; then
      SOAL_API_KEY="${BASH_REMATCH[1]}"; ok "المفتاح اتقرا صح ✔"; break
    fi
    warn "معرفتش ألاقي مفتاح صحيح — لازم يبدأ بـ sk-. حاول تاني ($attempt/3)"
  done
fi
[[ "${SOAL_API_KEY:-}" =~ ^sk- ]] || fail "مفتاح غير صحيح — لما تجيبه شغّل الـ installer تاني."

# --- 5) Write config.yaml ---
_src="${BASH_SOURCE[0]:-}"
if [ -n "$_src" ] && [ -f "$_src" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$_src")" && pwd)"
else
  SCRIPT_DIR="/tmp"
fi
unset _src
if [ -f "$SCRIPT_DIR/config.yaml" ]; then
  cp "$SCRIPT_DIR/config.yaml" "$AICHAT_DIR/config.yaml.tmp"
else
  curl -fsSL "${SOAL_INSTALL_REPO:-https://raw.githubusercontent.com/soalhelp/Soal.Help/main/linux-macos}/config.yaml" \
    -o "$AICHAT_DIR/config.yaml.tmp"
fi
sed "s|REPLACE_ME_WITH_SK_KEY|$SOAL_API_KEY|" "$AICHAT_DIR/config.yaml.tmp" > "$AICHAT_DIR/config.yaml"
rm "$AICHAT_DIR/config.yaml.tmp"
chmod 600 "$AICHAT_DIR/config.yaml"
ok "config.yaml → $AICHAT_DIR/config.yaml"

# --- 6) soal alias ---
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$rc" ] || continue
  if ! grep -q "alias soal=" "$rc" 2>/dev/null; then
    echo "alias soal='aichat'" >> "$rc"
  fi
done

echo
ok "التثبيت اكتمل!"
echo
echo -e "${CYAN}جرّب دلوقتي:${RESET}"
echo -e "  source ~/.bashrc"
echo -e "  ${GREEN}aichat 'hello!'${RESET}"
echo -e "  ${GREEN}aichat -m claude-opus${RESET}"
echo -e "  ${GREEN}aichat${RESET}"
