local vim = vim

return {
  "williamboman/mason.nvim", -- LSP Installer
  config = function()
    require "mason".setup {}
  end,
  lazy = true,
  cmd = { -- load this plugin when executing these commands.
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
  },
}

