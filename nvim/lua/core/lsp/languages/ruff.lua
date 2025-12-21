-- Ruff LSP設定 (Python linter/formatter)
-- Pyrightと併用: Ruff=linting/formatting, Pyright=type checking/hover
local M = {}

M.config = {
  init_options = {
    settings = {
      lineLength = 120,
      lint = {
        select = { "E", "F", "W", "I", "UP", "B", "C4", "SIM" },
      },
    },
  },
  on_attach = function(client, _)
    -- Pyrightのhoverを優先するため、Ruffのhoverを無効化
    client.server_capabilities.hoverProvider = false
  end,
}

return M
