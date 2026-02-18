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
        enabled = false,  -- Disable to allow ; and , as prefix keys for which-key
      },
      search = {
        enabled = false,  -- Disable to prevent interference with / search
      },
    },
  },
  keys = require("mappings").flash,
}
