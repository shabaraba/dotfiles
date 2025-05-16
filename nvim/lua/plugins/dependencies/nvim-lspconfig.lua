-- nvim-lspconfig用のパッチプラグイン
return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  priority = 50,  -- ESLintオーバーライドより後にロード
  init = function()
    -- ESLintの設定を修正するフック
    vim.api.nvim_create_autocmd("User", {
      pattern = "LspSetup",
      callback = function()
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")
        local util = require("lspconfig.util")
        
        -- ESLint設定のroot_dir関数をオーバーライド
        if configs.eslint then
          local original_root_dir = configs.eslint.document_config.default_config.root_dir
          
          configs.eslint.document_config.default_config.root_dir = function(fname, bufnr)
            -- fnameの型チェック
            if type(fname) == "number" then
              local ok, name = pcall(vim.api.nvim_buf_get_name, fname)
              fname = ok and name or vim.api.nvim_buf_get_name(0)
            end
            
            if not fname or fname == "" then
              fname = vim.api.nvim_buf_get_name(0)
            end
            
            if not fname or fname == "" then
              return vim.fn.getcwd()
            end
            
            -- オリジナルのroot_dir関数を呼び出す
            if original_root_dir then
              local ok, result = pcall(original_root_dir, fname)
              if ok then
                return result
              end
            end
            
            -- フォールバック
            local pattern = util.root_pattern(
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json",
              "package.json"
            )
            
            return pattern(fname) or util.find_git_ancestor(fname) or vim.fn.getcwd()
          end
        end
      end,
      once = true,
    })
  end,
}