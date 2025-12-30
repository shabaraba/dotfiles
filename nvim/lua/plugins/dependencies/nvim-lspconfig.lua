-- nvim-lspconfig: Neovim 0.11+ vim.lsp.config API使用
return {
  "neovim/nvim-lspconfig",
  lazy = false,  -- LSPは即座に読み込む
  config = function()
    -- ハンドラーとキーマッピングの統一設定
    require("core.lsp.handlers").setup()

    -- Neovim 0.11+ の新しいLSP設定APIを使用
    -- 参考: https://github.com/neovim/nvim-lspconfig/issues/3494
    require("core.lsp.config-v2").setup()

    -- Vue Hybrid Mode: vtsls に Vue サポートを追加
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    local vue_plugin_path = mason_path .. "/packages/vue-language-server/node_modules/@vue/language-server"
    if vim.fn.isdirectory(vue_plugin_path) == 1 then
      -- vtslsの設定を上書き（Vueプラグイン追加）
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
    end
  end,
  keys = require("mappings").lsp,
}
