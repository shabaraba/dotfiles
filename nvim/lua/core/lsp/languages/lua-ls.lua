-- Lua LSP設定 (Neovim開発用)
local M = {}

M.config = {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        setType = true,
        paramName = "All",
        paramType = true,
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}

return M
