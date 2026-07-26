#!/usr/bin/env bash
# Soal.help — Termux Reset / Uninstall

set -e

if [ -r /dev/tty ]; then TTY=/dev/tty; else TTY=/dev/stdin; fi

GREEN=$'\033[92m'; YELLOW=$'\033[93m'; CYAN=$'\033[96m'; RESET=$'\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${CYAN}   Soal.help — Reset Everything${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo
echo -e "${YELLOW}⚠️  ده هيمسح:${RESET}"
echo "   • Codex CLI (@mmmbuto/codex-cli-termux)"
echo "   • مجلد الإعدادات ~/.codex/ (كل ملفاته)"
echo "   • الـ launcher ~/bin/soal"
echo "   • السطور المضافة في ~/.bashrc / ~/.zshrc"
echo
read -rp "تأكيد المسح؟ (نعم/y): " ok < "$TTY"
case "${ok,,}" in
  y|yes|نعم|ن) ;;
  *) echo "اتلغى."; exit 0 ;;
esac

echo
echo -e "${CYAN}[i]${RESET} بأمسح Codex CLI..."
npm uninstall -g @mmmbuto/codex-cli-termux 2>/dev/null || true
npm uninstall -g @mmmbuto/codex-vl 2>/dev/null || true
npm uninstall -g @mmmbuto/codex-cli-lts 2>/dev/null || true

echo -e "${CYAN}[i]${RESET} بأمسح مجلد الإعدادات..."
rm -rf "$HOME/.codex" 2>/dev/null || true
rm -rf "$HOME/.local/share/codex" 2>/dev/null || true

echo -e "${CYAN}[i]${RESET} بأمسح الـ launcher..."
rm -f "$HOME/bin/soal" 2>/dev/null || true

echo -e "${CYAN}[i]${RESET} بأنظّف ~/.bashrc و ~/.zshrc..."
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$rc" ] || continue
  cp "$rc" "$rc.bak.$(date +%s)"
  sed -i \
    -e '/\.codex\/\.env/d' \
    -e '/HOME\/bin/d' \
    -e '/alias soal=/d' \
    -e '/SOAL_API_KEY/d' \
    -e '/__soal_key/d' \
    "$rc" || true
done

echo
echo -e "${GREEN}✔ اتنظّف كل حاجة${RESET}"
echo
echo -e "${CYAN}الخطوة القادمة:${RESET}"
echo -e "  1) اقفل Termux تمامًا (Force Stop)"
echo -e "  2) افتحه تاني"
echo -e "  3) شغّل الـ installer الجديد:"
echo -e "     ${YELLOW}curl -fsSL https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux/install.sh | bash${RESET}"
echo
