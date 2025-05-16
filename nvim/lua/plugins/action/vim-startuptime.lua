return {
  'dstein64/vim-startuptime',
  lazy = true,
  -- cmdオプションを削除し、手動でコマンドを定義
  keys = {
    { "<leader>st", "<cmd>StartupTime<cr>", desc = "Show startup time" },
  },
}