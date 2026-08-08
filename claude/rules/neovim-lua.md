---
paths:
  - "**/*.lua"
---

# Neovim Lua

- 既存ファイルへの上書き保存は `vim.cmd.write({ bang = true })` を使う。`vim.cmd("write")` はファイル名変更後や複数回実行される保存処理で `E13: File exists` エラーになる可能性がある
