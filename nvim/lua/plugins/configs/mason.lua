return {
  "williamboman/mason.nvim", -- LSP Installer
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    {
      "neovim/nvim-lspconfig",
      -- dependencies = { "hrsh7th/nvim-cmp" },
      config = function()
        local mason_lspconfig = require("mason-lspconfig")
        local on_attach = function(_, bufnr)
          vim.api.nvim_buf_set_option(bufnr, "formatexpr",
          "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
          -- _G.lsp_onattach_func(i, bufnr)
        end
        mason_lspconfig.setup_handlers({
          function(server_name)
            local opts = {
              on_attach = on_attach,
              settings = {
                ["omniSharp"] = {
                  useGlobalMono = "always"
                }
              },
            }
            require("lspconfig")[server_name].setup(opts)
          end,
        })
        vim.cmd("LspStart") -- 初回起動時はBufEnterが発火しない
      end,
      dependencies = { 
        "echasnovski/mini.completion", version = false,
        init = function()
          require("mappings").lsp()
        end,
        config = function()
          require('mini.completion').setup({})
          -- 3. completion (hrsh7th/nvim-cmp)
          -- local cmp = require("cmp")
          -- cmp.setup({
          --   snippet = {
          --     expand = function(args)
          --       vim.fn["vsnip#anonymous"](args.body)
          --     end,
          --   },
          --   sources = {
          --     { name = "nvim_lsp" },
          --     -- { name = "buffer" },
          --     -- { name = "path" },
          --   },
          --   mapping = cmp.mapping.preset.insert({
          --     ["<C-p>"] = cmp.mapping.select_prev_item(),
          --     ["<C-n>"] = cmp.mapping.select_next_item(),
          --     ['<C-l>'] = cmp.mapping.complete(),
          --     ['<C-e>'] = cmp.mapping.abort(),
          --     ["<CR>"] = cmp.mapping.confirm { select = true },
          --   }),
          --   experimental = {
          --     ghost_text = true,
          --   },
          -- })
          -- config hover design
          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover,
            {
              border = "single", -- "shadow" , "none", "rounded"
              -- width = 100,
            }
          )
          vim.cmd [[
            " autocmd ColorScheme * highlight NormalFloat guifg=gray guibg=#073642
            " autocmd ColorScheme * highlight FloatBorder guifg=gray guibg=#073642
            autocmd ColorScheme * highlight! link FloatBorder NormalFloat
          ]]
        end,
      },
      lazy = true,
      event = "InsertEnter",
    },
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require "mason".setup {}
  end,
  lazy = true,
  cmd = { -- load this plugin when executing these commands.
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
  },
}

