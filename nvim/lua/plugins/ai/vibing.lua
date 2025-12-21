return {
  "shabaraba/vibing.nvim",
  dev = true,
  ft = "vibing",
  keys = require("mappings").vibing,
  opts = {
    adapter = "agent_sdk",
    cli_path = "claude",
    chat = {
      window = {
        position = "right",
        width = 0.4,
        border = "rounded",
      },
      auto_context = true,
    },
    inline = {
      default_action = "fix",
    },
    keymaps = {
      send = "<CR>",
      cancel = "<C-c>",
      add_context = "<C-a>",
    },
  },
}
