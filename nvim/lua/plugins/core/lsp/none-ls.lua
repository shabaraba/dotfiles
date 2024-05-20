return {
  "nvimtools/none-ls.nvim",
  lazy = true,
  event = "BufRead",
  key = require("mappings").none_ls,
  dependencies = {"nvim-lua/plenary.nvim", "vim-test/vim-test"},
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.root_dir = opts.root_dir
      or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.formatting.fish_indent,
      nls.builtins.diagnostics.fish,
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.shfmt,
    })
  end,
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettier,
      },
    })
  end
}
