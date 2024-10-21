return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  keys = require("mappings").conform,
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "prettier", "eslint", stop_after_first = false },
      typescript = { "prettierd", "prettier", "eslint", stop_after_first = false },
      php = { "php_cs_fixer" },
      markdown = { "prettier", "markdownlint" },
    },
    -- format_on_save = {
    --   -- These options will be passed to conform.format()
    --   timeout_ms = 500,
    --   lsp_format = "fallback",
    -- },
    formatters = {
      php_cs_fixer = {
        command = "php-cs-fixer",
        args = { "fix", "--config=.php-cs-fixer.dist.php", "--no-interaction", "--quiet", "-" },
        stdin = true,
      },
    },
  },
}
