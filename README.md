# opencode-lite

Cấu hình opencode tối ưu cho máy yếu (Termux + PRoot Ubuntu trên Android).
Giữ nguyên các model chat **free của opencode Zen**, chỉ làm nhẹ để chạy mượt trên Termux.

## Model free đang dùng

`enabled_providers: ["opencode"]` — chỉ tải provider Zen, nhẹ RAM, không cần key Groq/DeepSeek riêng.

- Chính: `opencode/deepseek-v4-flash-free` (flash = nhanh, coding tốt, nhẹ cho Termux)
- Phụ/nhẹ: `opencode/nemotron-3.5-lightning-free` (tạo title, task nhỏ — nhanh nhất, ít token)

Các model free khác vẫn dùng được qua `/models` (đổi lúc chạy, không cần sửa config):

`big-pickle`, `mimo-v2.5-free`, `ling-3.0-flash-fin-free`,
`nemotron-3-ultra-free`,
`muse-spark-1.2-contributor-free`, `muse-spark-1.3-contributor-free`

> Free theo chính sách opencode Zen, có thể thay đổi. Xem: `oc-lite models` hoặc https://opencode.ai/docs/zen/

## Tối ưu Termux (chỉ giữ build code)

- `autoupdate: false` + `OPENCODE_DISABLE_AUTOUPDATE=true` — không check/tải binary mỗi lần mở
- `snapshot: false` — bỏ git snapshot (đỡ I/O trên PRoot)
- `share: disabled` — không upload session
- `permission deny: webfetch, websearch, skill` — cắt mạng/skill nặng, chỉ giữ `bash, read, edit, write, grep, glob` để build code
- `provider.opencode timeout 30s / chunk 15s` — fail nhanh, tránh treo máy yếu
- `compaction.prune: true, reserved: 4000` — xóa tool-output cũ, compaction ít giật lag
- `watcher.ignore` — bỏ qua node_modules, .git, dist, build, *.log, cache, vendor, .next
- Không set `shell` cứng — để opencode tự phát hiện shell Termux
- `server.hostname: 127.0.0.1` — chỉ listen local
- `subagent_depth: 0` — tắt subagent lồng nhau (đỡ RAM)
- `mcp: {}` — tắt MCP (đỡ RAM)
- `oc-lite`: `--pure` (tắt plugin ngoài), tắt LSP download, tắt mouse/title/filewatcher, `run` không TUI là nhẹ nhất
- TUI `simple`, tắt mouse/animation/sound/notification

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
