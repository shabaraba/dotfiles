-- return {
--   "shabaraba/pile.nvim",
--   lazy = false,
--   keys = require("mappings").pile,
-- }
--
return {
  -- Other plugin specifications
  {
    "pile.nvim",
    dir = "~/my_work/private/pile.nvim", -- Specify the local path to your plugin
    keys = require("mappings").pile,
    opts = {},
  },
}
