return {
  "SmiteshP/nvim-navic",
  dependencies = {
    "neovim/nvim-lspconfig"
  },
  lazy =true,
  event = "BufRead",
  opts = {
    lsp = {
      auto_attach = true,
    },
    highlight = true,
    lazy_update_context = false, -- set true if bad performance
  }
}

