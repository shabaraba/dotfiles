local vim = vim

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ctx)
    local set = vim.keymap.set
    local keymaps = require("mappings").lsp
    for _, v in pairs(keymaps) do
      set("n", v[1], v[2], {buffer = true})
    end
  end
})

return {
  "williamboman/mason-lspconfig.nvim",
  lazy = true,
  event = "BufRead",
  dependencies = {
    "williamboman/mason.nvim", -- LSP Installer
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    ensure_installed = {"lua_ls", "tsserver"},
    automatic_installation = true,
    handlers = {
      function(server_name)
        local on_attach = function(_, bufnr)
          vim.api.nvim_buf_set_option(bufnr, "formatexpr",
          "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
          -- _G.lsp_onattach_func(i, bufnr)
        end
        local opts = {
          on_attach = on_attach,
        }
        require("lspconfig")[server_name].setup({opts})
      end,
    }
  },
  keys = require("mappings").lsp,
}
