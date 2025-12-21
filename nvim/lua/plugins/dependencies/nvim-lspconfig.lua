-- nvim-lspconfig 手動設定（バグ回避用）
return {
  "neovim/nvim-lspconfig",
  lazy = false,  -- LSPは即座に読み込む
  config = function()
    -- ハンドラーとキーマッピングの統一設定
    require("core.lsp.handlers").setup()

    -- Vue Hybrid Mode: vtsls に Vue サポートを追加（vue_ls より先に設定が必要）
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    local vue_plugin_path = mason_path .. "/packages/vue-language-server/node_modules/@vue/language-server"
    if vim.fn.isdirectory(vue_plugin_path) == 1 then
      vim.lsp.config("vtsls", {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_plugin_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
          },
        },
      })
      vim.lsp.enable({ "vtsls", "vue_ls" })
    end

    -- LSP最適化モジュールで動的にサーバーを起動
    require("core.lsp.optimization").setup()
  end,
  keys = require("mappings").lsp,
}
