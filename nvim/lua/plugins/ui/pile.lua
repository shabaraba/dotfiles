-- return {
--   "shabaraba/pile.nvim",
--   lazy = false,
--   keys = require("mappings").pile,
-- }
--
return {
  -- Other plugin specifications
  {
    "pile.nvim",
    dir = "~/.config/nvim/lua/plugins/_developping/pile.nvim", -- Specify the local path to your plugin
    keys = require("mappings").pile,
    opts = {
      debug = {
        enabled = false,   -- デバッグ機能を有効化
        level = "sql",    -- ログレベルをsqlに設定（最も詳細）
        file_logging = true, -- ファイルへのログ出力を有効化
        sqlite = {
          trace_init = true, -- SQLite初期化のトレース
          trace_query = true, -- クエリ実行のトレース
        }
      },
      session = {
        enabled = true,               -- セッション機能の有効/無効
        auto_save = true,             -- 自動保存するか
        auto_load = true,             -- 起動時に自動で最後のセッションを読み込むか
        save_interval = 300,          -- 自動保存の間隔（秒）
        db_path = nil,                -- SQLiteのDBパス（nilの場合はデフォルト場所）
        save_on_exit = true,          -- 終了時に自動保存するか
        clear_buffers_on_load = false -- セッション読み込み時に既存バッファをクリアするか
      }
    },
  },
}
