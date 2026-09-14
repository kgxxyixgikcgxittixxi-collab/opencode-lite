# opencode-lite

Cấu hình opencode tối ưu cho máy yếu (Termux + PRoot Ubuntu trên Android).
Giữ nguyên các model chat **free của opencode Zen**, chỉ làm nhẹ để chạy mượt trên Termux.

## Model free đang dùng

`enabled_providers: ["opencode"]` — chỉ tải provider Zen, nhẹ RAM, không cần key Groq/DeepSeek riêng.

- Chính: `opencode/big-pickle` (free, coding tốt)
- Phụ/nhẹ: `opencode/nemotron-3.5-lightning-free` (tạo title, task nhỏ — nhanh, ít token)

Các model free khác vẫn dùng được qua `/models` (đổi lúc chạy, không cần sửa config):

`deepseek-v4-flash-free`, `mimo-v2.5-free`, `ling-3.0-flash-fin-free`,
`nemotron-3-ultra-free`, `big-pickle`,
`muse-spark-1.2-contributor-free`, `muse-spark-1.3-contributor-free`

> Free theo chính sách opencode Zen, có thể thay đổi. Xem: `oc-lite models` hoặc https://opencode.ai/docs/zen/

## Tối ưu Termux

- `autoupdate: false` — không tải lại binary 176MB mỗi lần mở
- `snapshot: false` — bỏ git snapshot (đỡ I/O trên PRoot)
- `share: disabled` — không upload session
- `compaction.prune: true` — xóa tool-output cũ, đỡ tràn context
- `watcher.ignore` — bỏ qua node_modules, .git, dist, build, *.log, cache
- Không set `shell` cứng — để opencode tự phát hiện shell Termux
- `server.hostname: 127.0.0.1` — chỉ listen local
- `subagent_depth: 0` — tắt subagent lồng nhau (đỡ RAM; máy khỏe có thể sửa thành `1`)
- `mcp: {}` — tắt MCP (đỡ RAM)
- TUI `simple`, tắt mouse/animation/sound/notification
- Script dùng `$HOME`, tự tìm binary, giảm `BUN_CONFIG_MAX_HTTP_REQUESTS` + `UV_THREADPOOL_SIZE` khi phát hiện Termux

## Cài đặt (Termux)

```bash
pkg install -y git curl nodejs-lts python sqlite
# cài opencode nếu chưa có:
curl -fsSL https://opencode.ai/install | bash

git clone https://github.com/kgxxyixgikcgxittixxi-collab/opencode-lite.git /tmp/opencode-lite
cd /tmp/opencode-lite
bash setup.sh
# mở lại Termux hoặc: export PATH="$HOME/.local/bin:$PATH"
```

PRoot Ubuntu / Linux thường: chỉ cần `git clone ... && bash setup.sh`.

## Sử dụng

```bash
oc-lite              # TUI nhẹ hằng ngày
oc-lite run "task"   # chạy task không TUI (nhẹ nhất, nên dùng khi máy lag)
oc-lite full         # TUI đầy đủ (bỏ qua preset nhẹ)
oc-lite models       # xem danh sách model free
oc-maintain          # dọn DB + log (chạy khi đã thoát opencode)
oc-maintain --prune  # + liệt kê session mới nhất
```

Lần đầu: mở `oc-lite`, chạy `/connect` -> chọn `opencode` -> login để dùng model free.
Key lưu ở `~/.local/share/opencode/auth.json`, không nằm trong config.

## License

MIT
