-- C/C++ LSP設定
local M = {}

M.config = {
  filetypes = { "c", "cpp", "mq5", "mqh" },
  settings = {
    clangd = {
      -- clangd専用の設定をここに追加
    }
  }
}

return M