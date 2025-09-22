-- uncomment this if you want to open nvim with a dir
-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
-- vim.cmd[[ au InsertEnter * set norelativenumber ]]
-- vim.cmd[[ au InsertLeave * set relativenumber ]]

-- Don't show any numbers inside terminals
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Open a file from its last left off position
-- vim.cmd [[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
-- File extension specific tabbing
vim.cmd [[ 
   augroup filetypes
     autocmd Filetype python          setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 
     autocmd Filetype lua             setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2 
     autocmd Filetype javascript      setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
     autocmd Filetype typescript      setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
     autocmd Filetype typescriptreact setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
    augroup END
]]

-- ジョブとプロセス管理の改善
local job_group = vim.api.nvim_create_augroup("JobManagement", { clear = true })

-- 終了時のジョブクリーンアップ
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = job_group,
  pattern = "*",
  callback = function()
    -- Neovimでは jobstart で開始したジョブのみ管理可能
    -- LSPクライアントの停止はvim.lsp.stop_client()で行う
    local clients = vim.lsp.get_clients()
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id)
    end
  end,
  desc = "Stop all running jobs before Vim exits"
})

-- 特殊バッファのbuftype設定
local buftype_group = vim.api.nvim_create_augroup("BufTypeManagement", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = buftype_group,
  pattern = "*",
  callback = function(ev)
    local buf = ev.buf
    local buftype = vim.bo[buf].buftype
    
    -- buftypeが空で特殊なバッファ名の場合は適切に設定
    if buftype == "" then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname:match("^term://") then
        vim.bo[buf].buftype = "terminal"
      elseif bufname:match("^fugitive://") then
        vim.bo[buf].buftype = "nofile"
      elseif bufname == "" and vim.api.nvim_buf_line_count(buf) == 1 and 
             vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "" then
        -- 空の無名バッファ
        vim.bo[buf].buftype = "nofile"
      end
    end
  end,
  desc = "Set appropriate buftype for special buffers"
})

-- タイムアウトの設定
vim.opt.updatetime = 300  -- CursorHold イベントのタイムアウト
vim.opt.timeoutlen = 500  -- キーマップのタイムアウト
