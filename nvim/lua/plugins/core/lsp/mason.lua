-- LSP Installer
--
return {
  "williamboman/mason.nvim",
  lazy = false,  -- Masonベースも即座に読み込む
  cmd = { -- load this plugin when executing these commands.
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
  },
  opts = {},
}
