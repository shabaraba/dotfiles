local vim = vim

-- ファイルタイプの設定
vim.cmd [[
  augroup zshAsBash
    autocmd!
    autocmd BufWinEnter *.zsh set filetype=sh
  augroup END
]]

vim.filetype.add({ extension = { mq5 = 'cpp', mqh = 'cpp' } })

-- Mason-lspconfigを本来の役割（インストール管理）のみに戻す
return {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,  -- Masonも即座に読み込む
  opts = {
    ensure_installed = {
      "lua_ls",
      "vtsls",  -- ts_lsの代替（より安定）
      -- "biome",  -- 一時的に無効化（nvim-lspconfigのバグ）
      "intelephense",
      "marksman",  -- Markdown LSP (wiki-link, Zettelkasten対応)
      -- "jdtls",  -- nvim-jdtlsプラグインで管理
      "eslint",  -- ESLint LSPサーバー
      "bashls",
      "gopls",
      "pyright",
      "ruff",  -- Python linter (pyright と併用)
      "rust_analyzer",
      -- "copilot-mcp"  -- 通常のCopilot suggestionを使用
    },
    automatic_installation = true,
    -- handlers は使わない（nvim-lspconfig.luaで手動設定）
  },
  config = function(_, opts)
    -- インストール管理のみ実行
    require("mason-lspconfig").setup(opts)
  end,
}
