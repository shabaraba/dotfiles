-- LSP Installer
--
return {
  "williamboman/mason.nvim",
  lazy = true,
  cmd = { -- load this plugin when executing these commands.
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
  },
  opts = {},
}
