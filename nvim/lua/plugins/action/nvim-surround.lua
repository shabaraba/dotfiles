return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  lazy = true,
  keys = require("mappings").surround,
  config = true,
  opts = {},
}
