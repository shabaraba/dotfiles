return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
  },
  keys = require("mappings").codecompanion,
  opts = {
    adapters = {
      acp = {
        claude_code = function()
          return require("codecompanion.adapters").extend("claude_code", {
            env = {
              CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
            },
          })
        end,
      },
    },
    strategies = {
      chat = {
        adapter = "claude_code",
      },
      inline = {
        adapter = "copilot",
      },
      cmd = {
        adapter = "copilot",
      },
    },
    display = {
      chat = {
        window = {
          layout = "vertical",
          width = 0.4,
          border = "rounded",
        },
        show_token_count = true,
      },
      action_palette = {
        provider = "default",
      },
    },
    opts = {
      log_level = "ERROR",
    },
  },
}
