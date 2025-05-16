-- LSP起動時間のベンチマーク
local M = {}

M.measure_startup = function()
  local start_time = vim.loop.hrtime()
  
  vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
      local end_time = vim.loop.hrtime()
      local duration = (end_time - start_time) / 1000000 -- ミリ秒に変換
      print(string.format("LSP startup time: %.2f ms", duration))
    end,
  })
end

-- コマンドを登録
vim.api.nvim_create_user_command("LspBenchmark", function()
  M.measure_startup()
  print("Open a file to start LSP benchmark...")
end, {})

return M