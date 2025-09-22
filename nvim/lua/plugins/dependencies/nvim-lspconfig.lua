-- nvim-lspconfig 手動設定（バグ回避用）
return {
  "neovim/nvim-lspconfig",
  lazy = false,  -- LSPは即座に読み込む
  config = function()
    -- ハンドラーとキーマッピングの統一設定
    require("core.lsp.handlers").setup()
    
    -- LSP最適化モジュールで動的にサーバーを起動
    require("core.lsp.optimization").setup()
  end,
  keys = require("mappings").lsp,
}
