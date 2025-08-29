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
  lazy = true,
  opts = {
    ensure_installed = {
      "lua_ls",
      "vtsls",  -- ts_lsの代替（より安定）
      -- "biome",  -- 一時的に無効化（nvim-lspconfigのバグ）
      "intelephense",
      "markdown_oxide",
      "jdtls",
      -- "eslint",  -- null-ls で代替するため無効化
      "bashls",
      "gopls",
      "pyright",
      "rust_analyzer",
      -- "copilot-mcp"  -- 通常のCopilot suggestionを使用
    },
    automatic_installation = false,
    -- handlers は使わない（nvim-lspconfig.luaで手動設定）
  },
  config = function(_, opts)
    -- インストール管理のみ実行
    require("mason-lspconfig").setup(opts)
  end,
}
