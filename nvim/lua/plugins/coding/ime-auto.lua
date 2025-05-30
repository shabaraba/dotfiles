return {
  "shabaraba/ime-auto.nvim",
  dir = vim.fn.stdpath("config") .. "/lua/plugins/_developing/ime-auto.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    require("ime-auto").setup({
      -- オプション設定（デフォルト値）
      escape_sequence = "ｋｊ",  -- エスケープシーケンス（全角文字）
      escape_timeout = 200,      -- タイムアウト（ミリ秒）
      os = "auto",              -- OS設定: "auto", "macos", "windows", "linux"
      ime_method = "builtin",   -- IME制御方法: "builtin", "custom"
      debug = false,            -- デバッグモード
    })
  end,
}
