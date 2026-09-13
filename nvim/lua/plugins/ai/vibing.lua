---@module "vibing"
-- 各Configクラスの@fieldが`?`無しで定義されており、一部だけ上書きする使い方だと
-- missing-fieldsが大量に出るため無効化する（補完には影響しない）
---@diagnostic disable: missing-fields

return {
  "shabaraba/vibing.nvim",
  dev = true,
  build = "./build.sh",
  ft = { "vibing" },
  cmd = { "VibingChat", "VibingInline", "VibingContext", "VibingToggleChat" },
  keys = require("mappings").vibing,
  ---@type Vibing.Config
  opts = {
    adapter = "claude",
    agent = {
      default_mode = "code",
      default_model = "opus",
      auto_resume_on_limit = {
        enabled = true,
      },
      chat_notifications = {
        enabled = true,
      },
      orchestration = {
        delegated_approval = true,
      },
      token_usage = {
        enabled = true,
        warn_context = 250000,
        auto_compact = {
          enabled = true,
          at = 300000,
        },
      },
    },
    permissions = {
      mode = "acceptEdits",
      allow = {
        "Edit",
        "Write",
        "Glob",
        "Grep",
        "WebSearch",
        "WebFetch",
        "webrun",
        "view_image",
        "Bash",
        "mcp__chrome-devtools__*",
        -- codex はサーバー名の `-` を `_` に正規化してからツール名を組み立てる
        "mcp__chrome_devtools__*",
      },
      ask = { "Bash(rm:*)" },
      deny = {},
      codex_profile_content = [[
default_permissions = "vibing-project"

[permissions.vibing-project]
description = "Workspace editing with Git metadata access"
extends = ":workspace"

[permissions.vibing-project.filesystem.":workspace_roots"]
".git" = "write"

[permissions.vibing-project.network]
enabled = true

]],
    },
    chat = {
      window = {
        position = "right",
        border = "rounded",
      },
      auto_context = false,
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
        Bash = "💻",
      },
    },
    mcp = {
      enabled = true,
      rpc_port = 9876,
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
      save_dir = vim.fn.expand("~/workspace/ObsidianVault/vault/Daily/private/"),
      file_finder_strategy = "auto", -- "auto" | "fd" | "ripgrep" | "find" | "locate"
    },
  },
}
