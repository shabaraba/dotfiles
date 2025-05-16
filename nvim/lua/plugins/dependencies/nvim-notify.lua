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
    level = 2,
    minimum_width = 50,
    render = "compact", -- default, minimal, simple, compact
    stages = "fade_in_slide_out",
    timeout = 3000,
    top_down = false,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    
    -- nvim-notifyをデフォルトの通知システムに設定
    vim.notify = notify
    
    -- Telescope拡張を読み込む
    require("telescope").load_extension("notify")
    
    -- キーマッピング
    vim.keymap.set("n", "<leader>fn", function()
      require("telescope").extensions.notify.notify()
    end, { desc = "Show notification history" })
    
    -- 通知履歴をクリアするコマンド
    vim.api.nvim_create_user_command("NotifyClear", function()
      notify.dismiss({ silent = true, pending = true })
    end, {})
  end,
}