return {
  "nvimtools/none-ls.nvim", -- null-ls のコミュニティフォーク
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    null_ls.setup({
      -- ログレベルを警告以上のみに制限
      log_level = "error", -- さらに厳しく制限
      debug = false,
      -- 通知を完全に無効化
      notify_format = "", -- 空文字で通知をブロック
      update_in_insert = false,
      should_attach = function(bufnr)
        -- 不要な通知を出さないように制御
        return vim.bo[bufnr].filetype ~= ""
      end,
      sources = {
        -- ESLint (none-ls-extrasから取得)
        require("none-ls.diagnostics.eslint_d").with({
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
          -- 通知を抑制
          on_attach = function(client, bufnr)
            -- 静かに動作させる
          end,
        }),
        
        -- コードアクション（通知抑制付き）
        require("none-ls.code_actions.eslint_d").with({
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
      
    })
  end,
}