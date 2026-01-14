return {
  "shabaraba/vibing.nvim",
  dev = true,
  build = "./build.sh",
  ft = "vibing",
  cmd = { "VibingChat", "VibingInline", "VibingContext", "VibingToggleChat" },
  keys = require("mappings").vibing,
  config = function()
    require("vibing").setup({
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
      chat = {
        window = {
          position = "right",
          border = "rounded",
        },
        auto_context = true,
        save_location_type = "project",
      },
      ui = {
        wrap = "on",
        tool_result_display = "none",
        gradient = {
          enabled = true,
          colors = {
            "#ff3300",
            "#5a5aff",
          },
          interval = 50,
        },
      },
      mcp = {
        enabled = true,
        rpc_port = 9876,
        auto_setup = true,
        auto_configure_claude_json = true
      },
      ollama = {
        enabled = true,
        model = "qwen2.5-coder:1.5b",
        url = "http://localhost:11434",
        timeout = 30000,
        stream = true,
        use_for_title = true,
        use_for_doc = true,
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
