return {
  "shabaraba/vibing.nvim",
  dev = true,
  build = "./build.sh",
  ft = "vibing",
  cmd = { "VibingChat", "VibingInline", "VibingContext", "VibingToggleChat" },
  keys = require("mappings").vibing,
  opts = {
    agent = {
      default_mode = "code",
      default_model = "sonnet",
    },
    permissions = {
      mode = "acceptEdits",
      allow = { "Skill", "Read", "Edit", "Write", "Glob", "Grep", "WebSearch", "WebFetch", "Bash", "mcp__chrome-devtools__*" },
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
      tool_markers = {
        default = "⏺",
        Task = "▶",
        TaskComplete = "✓",
        Read = "📄",
        Edit = "✏️",
        Write = "📝",
        Bash = {
          default = "💻",
          patterns = {
            ["^(npm|pnpm|yarn|bun) install"] = "📦⬇",
            ["^(npm|pnpm|yarn|bun) run"] = "📦▶",
            ["^yarn "] = "📦▶",
            ["^git commit"] = "🌿💾",
            ["^git push"] = "🌿⬆",
            ["^docker build"] = "🐳🔨",
            ["^docker run"] = "🐳▶",
          }
        },
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
    daily_summary = {
      search_dirs = {
        vim.fn.expand("~/workspace"),
      },
      save_dir = vim.fn.expand("~/workspace/ObsidianVault/vault/Daily/"),
      file_finder_strategy = "auto", -- "auto" | "fd" | "ripgrep" | "find" | "locate"
    },
  },
}
