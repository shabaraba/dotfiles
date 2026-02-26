return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = require("mappings").conform,
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