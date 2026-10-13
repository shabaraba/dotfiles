---@module "vibing"
-- 各Configクラスの@fieldが`?`無しで定義されており、一部だけ上書きする使い方だと
-- missing-fieldsが大量に出るため無効化する（補完には影響しない）
---@diagnostic disable: missing-fields

-- アダプタごとの綴り分けは不要。can_use_tool は canonical 名（Claude語彙）で照合し、
-- 各backendの native 名は *_tool_vocabulary が変換する。MCPサーバー名の `-` / `_` 揺れも
-- matchers 側で吸収される（codexは `-` を `_` に正規化した名前を送ってくる）
local allow = {
	"Edit",
	"Write",
	"WebSearch",
	"WebFetch",
	"Bash",
	"mcp__chrome-devtools__*",
	"mcp__codegraph__*",
}

local ask = {
	"Bash(rm:*)",
}

local deny = {}

local codex_profile_content = [[
default_permissions = "vibing-project"

[permissions.vibing-project]
description = "Workspace editing with Git metadata access"
extends = ":workspace"

[permissions.vibing-project.filesystem.":workspace_roots"]
".git" = "write"

[permissions.vibing-project.network]
enabled = true

]]

return {
	"shabaraba/vibing.nvim",
	dev = true,
	build = "./build.sh",
	ft = { "vibing" },
	cmd = { "VibingChat", "VibingInline", "VibingContext", "VibingToggleChat" },
	keys = require("mappings").vibing,
	---@type Vibing.Config
	opts = {
		ai = {
			chat = {
				agent = "claude",
				model = "sonnet",
			},
			agents = {
				claude = {
					process = "duplex",
				},
				codex = {
					process = "duplex",
					extensions = {
						approval_policy = "on-request",
						profile_content = codex_profile_content,
					},
				},
				-- 現在のvibing.nvimはPi未対応。対応版で有効化する際の設定を保存。
				-- pi = {
				--   path = vim.fn.expand("~/.local/share/pi-agent/node_modules/.bin/pi"),
				--   extensions = { provider = "bonsai-local" },
				-- },
				-- bonsai-localはllama-server :8080、modelはbonsai2-27b。
			},
		},
		automation = {
			limits = {
				resume = { enabled = true },
			},
			orchestration = {
				notifications = { enabled = true },
			},
		},
		permissions = {
			mode = "acceptEdits",
			allow = allow,
			ask = ask,
			deny = deny,
			delegated_approval = true,
		},
		chat = {
			context = {
				auto_include = false,
				warn_tokens = 250000,
				compaction = {
					enabled = true,
					threshold_tokens = 300000,
				},
			},
			storage = { location = "project" },
			language = { default = "ja", chat = "ja" },
			daily_summary = {
				search_dirs = {
					vim.fn.expand("~/workspace"),
				},
				save_dir = vim.fn.expand("~/workspace/ObsidianVault/vault/Daily/private/"),
				file_finder_strategy = "auto", -- "auto" | "fd" | "ripgrep" | "find" | "locate"
			},
		},
		ui = {
			window = {
				position = "right",
				border = "rounded",
			},
			wrap = "on",
			usage = { enabled = true },
			gradient = {
				enabled = true,
				colors = { "#ff3300", "#5a5aff" },
				interval_ms = 50,
			},
			tools = {
				results = "none",
				markers = {
					default = "⏺",
					Task = "▶",
					TaskComplete = "✓",
					Read = "📄",
					Edit = "✏️",
					Write = "📝",
					Bash = "💻",
				},
			},
		},
		integrations = {
			nvim = { enabled = true, port = 9876 },
		},
		keymaps = {
			send = "<CR>",
			cancel = "<C-c>",
			add_context = "<C-a>",
		},
	},
}
