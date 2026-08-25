-- who-called.nvim: Debug plugin to trace which plugin called a function

return {
  "shabaraba/who-called.nvim",
  dev = true,  -- Use local development version from ~/workspaces/nvim-plugins
  -- 機能自体を enabled=false で使っていないため spec ごと無効化する。
  -- lazy=false だと dependencies の noice / nvim-notify / telescope まで
  -- 起動時ロードに巻き込み、startuptime を ~30ms 押し上げていた。
  enabled = false,
  dependencies = { "folke/noice.nvim" },  -- Load after noice.nvim to wrap vim.notify properly
  config = function()
    require("who-called").setup({
      enabled = false,           -- Disabled by default for performance
      history_limit = 100,
      show_in_notify = true,
      track_notify = true,
      track_windows = true,
      track_diagnostics = true,
      track_buffers = true,
    })
  end,
}
