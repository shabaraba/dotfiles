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
  -- opts = {
  --   -- ensure_installed = {"lua_ls", "tsserver"},
  --   -- automatic_installation = true,
  --   -- handlers = {
  --   --   function(server_name)
  --   --     print(server_name)
  --   --     require("lspconfig")[server_name].setup({opts})
  --   --   end,
  --   -- }
  -- },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup {
      ensure_installed = {"lua_ls", "tsserver"},
      automatic_installation = true,
    }
    local on_attach = function(_, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "formatexpr",
      "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
      -- _G.lsp_onattach_func(i, bufnr)
    end
    local lspconfig = require("lspconfig")
    mason_lspconfig.setup_handlers({
      function(server_name)
        -- if server_name == 'tsserver' then
        --    lspconfig.tsserver.setup {
        --        cmd = { 
        --            "~/.local/share/nvim/mason/packages/typescript-language-server/node_modules/.bin/typescript-language-server", 
        --            "--stdio"
        --        },
        --        on_attach = function(client, bufnr)
        --            -- オプションでここに設定を追加
        --        end,
        --    }
        -- else
        --    lspconfig[server_name].setup {}
        -- end
        require("lspconfig")[server_name].setup({opts})
      end,
    })
    vim.cmd("LspStart") -- 初回起動時はBufEnterが発火しない
  end,
  keys = require("mappings").lsp,
}
