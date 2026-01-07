return {
  "shabaraba/vibing.nvim",
  dev = true,
  dir = "~/workspaces/nvim-plugins/vibing.nvim", -- worktreeのパスを指定
  build = "./build.sh",
  ft = "vibing",
  cmd = { "VibingChat", "VibingInline", "VibingContext", "VibingToggleChat" },
  keys = require("mappings").vibing,
  config = function()
    require("vibing").setup({
      mcp = {
        enabled = true,
        rpc_port = 9876,
        auto_setup = true,
        auto_configure_claude_json = true
      },
      chat = {
        window = {
          position = "right",
          border = "rounded",
        },
        auto_context = true,
        save_location_type = "project",
      },
      agent = {
        default_mode = "code",
        default_model = "sonnet",
      },
      permissions = {
        mode = "acceptEdits",
        allow = { "Read", "Edit", "Write", "Glob", "Grep", "WebSearch", "WebFetch", "Bash" },
        ask = { "Bash(rm:*)" },
        deny = {},
      },
      ui = {
        wrap = "on",                  -- デフォルトで折り返し有効
        tool_result_display = "none", -- "none", compact", "full"
        gradient = {
          enabled = true,             -- Enable gradient animation during AI response
          colors = {
            "#ff3300",                -- Start color
            "#5a5aff",                -- End color
          },
          interval = 50,              -- Animation update interval in milliseconds
        },
      },
      preview = {
        enabled = true
      },
      language = {
        default = "ja",
        chat = "ja",
        inline = "ja",
      },
      keymaps = {
        send = "<CR>",
        cancel = "<C-c>",
        add_context = "<C-a>",
      },
    })
  end,
}
