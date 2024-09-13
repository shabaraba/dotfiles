local vim = vim

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ctx)
    local set = vim.keymap.set
    local keymaps = require("mappings").lsp
    for _, v in pairs(keymaps) do
      set("n", v[1], v[2], { buffer = true })
    end
  end
})

return {
  "williamboman/mason-lspconfig.nvim",
  lazy = true,
  event = "BufReadPre",
  ft = { 'lua', 'typescript', 'javascript', 'php' }, -- 対象のファイルタイプを指定
  opts = {
    ensure_installed = { "ts_ls", "intelephense" },
    automatic_installation = true,
    handlers = {
      function(server_name)
        local on_attach = function(client, bufnr)
          -- enable inlay hint
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(bufnr, true)
          end

          vim.api.nvim_buf_set_option(bufnr, "formatexpr",
            "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
        end
        local opts = {
          on_attach = on_attach,
          inlay_hint = {
            enabled = true,
          },
        }
        if server_name == "ts_ls" then
          opts.settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            },
            golang = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            },
          }
        end
        require("lspconfig")[server_name].setup({ opts })
      end,
    }
  },
  keys = require("mappings").lsp,
}

-- dependencies = {
--   "neovim/nvim-lspconfig",
--   "nvim-lua/plenary.nvim",
--   "ray-x/lsp_signature.nvim",
-- },
