return {
  "nvim-treesitter/nvim-treesitter",
  event = "VimEnter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {"lua", "vim", "php", "typescript", "java", "javascript", "html" },
      sync_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
