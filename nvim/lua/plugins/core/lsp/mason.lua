-- LSP Installer
--
return {
  "williamboman/mason.nvim",
  cmd = { -- load this plugin when executing these commands.
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
  },
  opts = {},
}
