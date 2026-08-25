-- nvim-notify は noice のエラー/警告表示バックエンドとしてオンデマンドロードされる。
-- vim.notify の所有とメッセージのフィルタリングは noice 側 (plugins/ui/noice.lua) が担うため、
-- ここでは表示設定のみ行い、vim.notify を上書きしないこと
-- （遅延ロード時に上書きすると起動時に noice が取った所有権を奪ってしまう）。

return {
  "rcarriga/nvim-notify",
  lazy = true,
  opts = {
    background_colour = "#000000",
    fps = 30,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = "",
    },
    level = "WARN", -- ERRORとWARNのみ表示（INFOとDEBUGを非表示）
    minimum_width = 50,
    render = "compact", -- default, minimal, simple, compact
    stages = "fade_in_slide_out",
    timeout = 3000,
    top_down = false,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)

    -- 通知履歴をクリアするコマンド
    vim.api.nvim_create_user_command("NotifyClear", function()
      notify.dismiss({ silent = true, pending = true })
    end, {})
  end,
}
