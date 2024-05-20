return {
  'phaazon/hop.nvim',
  branch = 'v2', -- optional but strongly recommended
  config = true,
  opts = {
    keys = 'asertyuiohjkl',
  },
  lazy = true,
  keys = require("mappings").hop,
}

