return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      php = { "php_cs_fixer" },
    },
    formatters = {
      php_cs_fixer = {
        command = "php-cs-fixer",
        args = { "fix", "--config=.php-cs-fixer.dist.php", "--no-interaction", "--quiet", "-" },
        stdin = true,
      },
    },
  },
}
