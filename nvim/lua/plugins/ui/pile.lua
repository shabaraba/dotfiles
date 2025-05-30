return {
  {
    "shabaraba/pile.nvim",
    lazy = false,  -- 起動時にロード
    keys = require("mappings").pile,
    opts = {
      debug = {
        enabled = false,   -- デバッグを無効化
        level = "error",   -- エラーレベルのみ
        file_logging = true,
        sqlite = {
          trace_init = false,
          trace_query = false,
        }
      },
      session = {
        enabled = true,
        auto_save = true,
        auto_load = true,
        save_interval = 300,
        db_path = nil,
        save_on_exit = true,
        clear_buffers_on_load = false
      }
    },
    -- config関数は削除し、プラグインのデフォルト設定に任せる
  },
}