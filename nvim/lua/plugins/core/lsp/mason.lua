return {
  "williamboman/mason.nvim", -- LSP Installer
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

