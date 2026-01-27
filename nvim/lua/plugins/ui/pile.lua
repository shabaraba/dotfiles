return {
  {
    "shabaraba/pile.nvim",
    lazy = false, -- 起動時にロード
    dev = true,
    keys = require("mappings").pile,
    opts = {
      debug = {
        enabled = false, -- デバッグを無効化
        level = "error", -- エラーレベルのみ
        file_logging = true,
        sqlite = {
          trace_init = false,
          trace_query = false,
        }
      },
      session = {
        auto_save = true,      -- 終了時に自動保存
        auto_restore = true,   -- 起動時に自動復元
        preserve_order = true, -- 並び順を保持
      },
    },
  },
}
