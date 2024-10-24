-- return {
--   "shabaraba/pile.nvim",
--   lazy = false,
--   keys = require("mappings").pile,
-- }
--
return {
  -- Other plugin specifications
  {
    "plugin-devtools.nvim",
    dir = "~/.config/nvim/lua/plugins/_developping/plugin-devtools.nvim", -- Specify the local path to your plugin
    lazy = true,
    ft = "lua",
    opts = {
      plugin_manager= "Lazy",
      watch_dirs = {
        os.getenv("HOME") .. "/dotfiles/nvim",
      },
    },
  },
}
