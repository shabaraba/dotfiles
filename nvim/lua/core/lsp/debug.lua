-- LSPデバッグ用のヘルパー関数
local M = {}

M.trace_eslint = function()
  -- ESLintの設定を直接確認
  local lspconfig = require("lspconfig")
  local eslint_config = lspconfig.eslint
  
  print("ESLint LSP Config:")
  print(vim.inspect(eslint_config))
  
  -- インストール済みのLSPサーバーを確認
  local mason_lspconfig = require("mason-lspconfig")
  local installed_servers = mason_lspconfig.get_installed_servers()
  
  print("\nInstalled LSP servers:")
  print(vim.inspect(installed_servers))
end

-- ESLintのroot_dir関数をラップしてデバッグ
M.wrap_eslint_root_dir = function()
  local lspconfig = require("lspconfig")
  local original_root_dir = lspconfig.eslint.document_config.default_config.root_dir
  
  lspconfig.eslint.document_config.default_config.root_dir = function(fname)
    print("ESLint root_dir called with fname:", fname, type(fname))
    
    -- fnameがnilまたは数値の場合の処理
    if type(fname) == "number" or not fname then
      fname = vim.api.nvim_buf_get_name(0)
      print("Converted fname to:", fname)
    end
    
    if original_root_dir then
      return original_root_dir(fname)
    else
      return vim.fn.getcwd()
    end
  end
end

return M