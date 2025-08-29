-- nvim-lspconfig 手動設定（バグ回避用）
return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  ft = {
    'lua',
    'typescript',
    'javascript',
    'php',
    'markdown',
    'vue',
    "typescriptreact",
    "javascriptreact",
    "java",
    "bash",
    "c",
    "cpp",
    "mq5",
    "mqh",
    "go"
  },
  config = function()
    -- ハンドラーとキーマッピングの統一設定
    require("core.lsp.handlers").setup()
    
    -- Manual LSP setup（バグ回避）
    local lspconfig = require("lspconfig")
    local handlers = require("core.lsp.handlers")
    local capabilities = handlers.capabilities()
    local on_attach = handlers.on_attach
    
    -- 手動LSPセットアップ（nvim-lspconfigのバグ回避）
    lspconfig.vtsls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
    })
    
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    
    lspconfig.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    
    lspconfig.gopls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    
    -- Copilot MCPは使わず、通常のsuggestion機能を使用
  end,
  keys = require("mappings").lsp,
}
