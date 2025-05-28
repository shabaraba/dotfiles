local vim = vim

-- ファイルタイプの設定
vim.cmd [[
  augroup zshAsBash
    autocmd!
    autocmd BufWinEnter *.zsh set filetype=sh
  augroup END
]]

vim.filetype.add({ extension = { mq5 = 'cpp', mqh = 'cpp' } })

return {
  "williamboman/mason-lspconfig.nvim",
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
  }, -- 対象のファイルタイプを指定
  opts = {
    ensure_installed = {
      "lua_ls",
      "ts_ls",
      "intelephense",
      "markdown_oxide",
      "jdtls",
      -- "eslint",  -- null-ls で代替するため無効化
      "bashls",
      "gopls",
      "pyright",
      "rust_analyzer",
    },
    automatic_installation = false,
    handlers = {
      function(server_name)
        -- すべてのサーバーを統一的に処理
        local lsp_opt = require("core.lsp.optimization")
        lsp_opt.setup_server(server_name)
      end,
    }
  },
  config = function(_, opts)
    -- ハンドラーとキーマッピングの統一設定
    require("core.lsp.handlers").setup()
    
    require("mason-lspconfig").setup(opts)
    
    -- LSP最適化の初期化
    require("core.lsp.optimization").setup()
  end,
  keys = require("mappings").lsp,
}
