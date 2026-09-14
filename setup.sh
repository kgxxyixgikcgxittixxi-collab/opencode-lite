#!/usr/bin/env bash
# setup.sh — cài đặt opencode-lite config cho máy yếu
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== opencode-lite setup ==="

# Tạo thư mục config nếu chưa có
mkdir -p ~/.config/opencode ~/.local/bin

# Backup config cũ
if [ -f ~/.config/opencode/opencode.json ]; then
  cp ~/.config/opencode/opencode.json ~/.config/opencode/opencode.json.bak 2>/dev/null || true
  echo "[1/4] Da backup config cu -> opencode.json.bak"
fi

# Copy config
cp "$DIR/config/opencode.json" ~/.config/opencode/opencode.json
cp "$DIR/config/tui.json" ~/.config/opencode/tui.json
echo "[2/4] Da copy config"

# Copy scripts
cp "$DIR/bin/oc-lite" ~/.local/bin/oc-lite
cp "$DIR/bin/oc-maintain" ~/.local/bin/oc-maintain
chmod +x ~/.local/bin/oc-lite ~/.local/bin/oc-maintain
echo "[3/4] Da copy scripts"

# Kiểm tra PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo '[4/4] Can them ~/.local/bin vao PATH. Them vao ~/.bashrc:'
  echo '  export PATH="$HOME/.local/bin:$PATH"'
else
  echo "[4/4] PATH OK"
fi

echo ""
echo "=== Hoan thanh! ==="
echo "  oc-lite              # TUI nhe hang ngay"
echo "  oc-lite run \"task\"   # Chay task khong TUI (nhe nhat)"
echo "  oc-maintain          # Don DB + log (chay khi da thoat opencode)"
