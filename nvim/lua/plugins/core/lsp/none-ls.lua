return {
  "nvimtools/none-ls.nvim", -- null-ls のコミュニティフォーク
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    null_ls.setup({
      sources = {
        -- ESLint (デフォルトのESLint LSPの代替)
        diagnostics.eslint_d.with({
          diagnostics_format = '[eslint] #{m}\n(#{c})',
          condition = function(utils)
            return utils.root_has_file({ 
              ".eslintrc", 
              ".eslintrc.js", 
              ".eslintrc.json",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              "package.json" 
            })
          end,
        }),
        
        -- コードアクション
        code_actions.eslint_d,
        
        -- Prettier
        formatting.prettier.with({
          condition = function(utils)
            return utils.root_has_file({ ".prettierrc", ".prettierrc.js", "prettier.config.js" })
          end,
        }),
        
        -- Stylua (Lua formatter)
        formatting.stylua.with({
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
        }),
        
        -- Black (Python formatter)
        formatting.black.with({
          condition = function(utils)
            return utils.root_has_file({ "pyproject.toml", ".black" })
          end,
        }),
      },
      
      -- null-lsの診断設定
      diagnostic_config = {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
      },
      
      -- フォーマット設定
      on_attach = function(client, bufnr)
        -- ESLint LSPが無効になっているか確認
        local active_clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        for _, c in ipairs(active_clients) do
          if c.name == "eslint" then
            c.stop()
          end
        end
      end,
    })
  end,
}