return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labels = "asertyuiohjkl", -- Same as hop.nvim for consistency
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
      incremental = true,
    },
    jump = {
      autojump = false,
    },
    modes = {
      char = {
        enabled = true,
        autohide = false,
        jump_labels = true,
      },
      search = {
        enabled = true,
      },
    },
  },
  keys = require("mappings").flash,
}
