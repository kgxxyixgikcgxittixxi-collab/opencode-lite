#!/usr/bin/env bash
# setup.sh — cài đặt opencode-lite cho Termux / PRoot Ubuntu / Linux
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="${HOME:-$(eval echo ~)}"

echo "=== opencode-lite setup ==="

# Phát hiện môi trường
IS_TERMUX=0
if [ -n "${PREFIX:-}" ] && [ -d "/data/data/com.termux" ]; then IS_TERMUX=1; fi
echo "HOME=$HOME_DIR | Termux=$IS_TERMUX"

mkdir -p "$HOME_DIR/.config/opencode" "$HOME_DIR/.local/bin"

# Kiểm tra tool cần thiết (không tự cài để giữ nhẹ, chỉ nhắc)
for t in python3; do
  if ! command -v "$t" >/dev/null 2>&1; then
    echo "[!] Thiếu $t. Termux: pkg install python | Ubuntu: sudo apt install python3"
  fi
done
if [ "$IS_TERMUX" = "1" ] && ! command -v sqlite3 >/dev/null 2>&1; then
  echo "[i] Gợi ý Termux: pkg install sqlite (để oc-maintain vacuum DB nhanh hơn, không bắt buộc)"
fi

# Backup config cũ
if [ -f "$HOME_DIR/.config/opencode/opencode.json" ]; then
  cp "$HOME_DIR/.config/opencode/opencode.json" "$HOME_DIR/.config/opencode/opencode.json.bak" 2>/dev/null || true
  echo "[1/4] Đã backup config cũ -> opencode.json.bak"
fi
if [ -f "$HOME_DIR/.config/opencode/tui.json" ]; then
  cp "$HOME_DIR/.config/opencode/tui.json" "$HOME_DIR/.config/opencode/tui.json.bak" 2>/dev/null || true
fi

# Copy config (giữ nguyên model free opencode Zen)
cp "$DIR/config/opencode.json" "$HOME_DIR/.config/opencode/opencode.json"
cp "$DIR/config/tui.json" "$HOME_DIR/.config/opencode/tui.json"
echo "[2/4] Đã copy config (model free: big-pickle + nemotron-lightning-free)"

# Validate JSON
python3 -c "import json; json.load(open('$HOME_DIR/.config/opencode/opencode.json')); json.load(open('$HOME_DIR/.config/opencode/tui.json')); print('JSON OK')"

# Copy scripts
cp "$DIR/bin/oc-lite" "$HOME_DIR/.local/bin/oc-lite"
cp "$DIR/bin/oc-maintain" "$HOME_DIR/.local/bin/oc-maintain"
chmod +x "$HOME_DIR/.local/bin/oc-lite" "$HOME_DIR/.local/bin/oc-maintain"
bash -n "$HOME_DIR/.local/bin/oc-lite" && bash -n "$HOME_DIR/.local/bin/oc-maintain"
echo "[3/4] Đã copy scripts + check syntax OK"

# Kiểm tra PATH
if ! echo "$PATH" | grep -q "$HOME_DIR/.local/bin"; then
  echo '[4/4] Cần thêm ~/.local/bin vào PATH. Thêm vào ~/.bashrc:'
  echo '  export PATH="$HOME/.local/bin:$PATH"'
else
  echo "[4/4] PATH OK"
fi

# Kiểm tra binary opencode
if ! command -v opencode >/dev/null 2>&1 && [ ! -x "$HOME_DIR/.opencode/bin/opencode" ]; then
  echo ""
  echo "[i] Chưa thấy binary opencode. Cài bằng:"
  echo "  curl -fsSL https://opencode.ai/install | bash"
  if [ "$IS_TERMUX" = "1" ]; then
    echo "  (Termux: pkg install curl git nodejs-lts python -y trước)"
  fi
fi

echo ""
echo "=== Hoàn thành! ==="
echo "  oc-lite              # TUI nhẹ hằng ngày (free Zen)"
echo "  oc-lite run \"task\"   # Chạy task không TUI (nhẹ nhất)"
echo "  oc-lite models       # Xem danh sách model free"
echo "  oc-maintain          # Dọn DB + log (chạy khi đã thoát opencode)"
echo ""
echo "Sau khi cài, mở opencode và chạy /connect -> login opencode Zen để dùng model free."
