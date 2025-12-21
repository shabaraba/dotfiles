-- who-called.nvim: Debug plugin to trace which plugin called a function

return {
  "shabaraba/who-called.nvim",
  dev = true,  -- Use local development version from ~/workspaces/nvim-plugins
  lazy = false,  -- Eager load to ensure it wraps vim.notify before noice checks
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
