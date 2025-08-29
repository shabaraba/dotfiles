return {
  "coder/claudecode.nvim",
  cmd = "ClaudeCode",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = require("mappings").claudecode,
}
