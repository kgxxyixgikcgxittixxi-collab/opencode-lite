# opencode-lite

Cấu hình opencode tối ưu cho máy yếu (Termux + PRoot Ubuntu trên Android).

## Vấn đề

- Máy ảo PRoot chậm I/O — DB lớn làm `session list` treo
- Binary opencode 176MB, `autoupdate` tải lại mỗi lần mở
- Session dài → tràn context (Groq 128K)
- Lỗi `reasoning encrypted_content` khi dùng opencode free tier
- API key lộ trong config cũ

## Giải pháp

- `autoupdate: false` — tắt tự cập nhật binary
- `snapshot: false` — bỏ git snapshot tracking (đỡ I/O trên PRoot)
- `share: disabled` — không upload session
- `enabled_providers: ["groq", "deepseek"]` — chỉ bật provider cần thiết
- `compaction.prune: true` — tự xóa tool outputs cũ, tiết kiệm context
- `watcher.ignore` — bỏ qua node_modules, .git, dist, build
- TUI: tắt mouse, animations, sound, notifications
- `oc-lite run` — chạy task không TUI, nhẹ nhất
- `oc-maintain` — vacuum DB định kỳ

## Cài đặt

```bash
git clone https://github.com/Rem007/opencode-lite.git /tmp/opencode-lite
cd /tmp/opencode-lite
bash setup.sh
```

## Sử dụng

```bash
oc-lite              # TUI nhẹ hằng ngày
oc-lite run "task"   # chạy task không TUI (nhẹ nhất, nên dùng khi máy lag)
oc-lite full         # TUI đầy đủ
oc-maintain          # dọn DB + log (chạy khi đã thoát opencode)
oc-maintain --prune  # + liệt kê 5 session nặng nhất
```

## Provider

Sau khi cài, chạy `/connect` trong TUI để nhập API key:

- **Groq** (miễn phí, 128K context) — `https://console.groq.com/`
- **DeepSeek** (trả phí, 128K context) — `https://platform.deepseek.com/`

API key được lưu trong `~/.local/share/opencode/auth.json` (không ở trong config).

## License

MIT