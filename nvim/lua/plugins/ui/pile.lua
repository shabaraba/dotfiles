return {
  {
    "shabaraba/pile.nvim",
    lazy = false,  -- 起動時にロード
    keys = require("mappings").pile,
    opts = {
      debug = {
        enabled = true,    -- デバッグを有効化
        level = "sql",
        file_logging = true,
        sqlite = {
          trace_init = true,
          trace_query = true,
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