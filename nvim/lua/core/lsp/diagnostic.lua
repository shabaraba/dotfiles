-- LSP診断設定のベストプラクティス
local M = {}

M.setup = function()
  -- 診断設定
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      source = "if_many", -- 複数のLSPがある場合のみソースを表示
      format = function(diagnostic)
        if diagnostic.severity == vim.diagnostic.severity.ERROR then
          return string.format("E: %s", diagnostic.message)
        end
        return diagnostic.message
      end,
    },
    severity_sort = true,
    float = {
      source = "always",
      border = "rounded",
    },
    update_in_insert = false,
    underline = true,
    signs = true,
  })

  -- 診断サインの設定
  local signs = { 
    Error = "󰅚 ", 
    Warn = "󰀪 ", 
    Hint = "󰌶 ", 
    Info = " " 
  }
  
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- 診断の自動表示を設定
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = 0,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })
end

-- 診断ナビゲーションのキーマップ
M.setup_keymaps = function()
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
end

return M