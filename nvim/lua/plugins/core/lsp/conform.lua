return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>mp",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[mp] Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      svelte = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      lua = { "stylua" },
      python = { "black" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    },
    formatters = {
      prettier = {
        condition = function(self, ctx)
          return vim.fs.find({ ".prettierrc", ".prettierrc.js", "prettier.config.js" }, { path = ctx.filename, upward = true })[1]
        end,
      },
      stylua = {
        condition = function(self, ctx)
          return vim.fs.find({ "stylua.toml", ".stylua.toml" }, { path = ctx.filename, upward = true })[1]
        end,
      },
      black = {
        condition = function(self, ctx)
          return vim.fs.find({ "pyproject.toml", ".black" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
}