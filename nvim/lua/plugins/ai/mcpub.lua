local vim = vim;

return {
  "ravitemer/mcphub.nvim",
  cmd = { "McpHub" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest",
  config = function()
    require("mcphub").setup()
  end,
}
