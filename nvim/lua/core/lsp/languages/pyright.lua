-- Pyright LSP設定 (型チェック・hover用)
-- Ruffと併用: Pyright=type checking/hover, Ruff=linting/formatting
local M = {}

M.config = {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = true,
        diagnosticSeverityOverrides = {
          reportUnusedImport = "none",  -- Ruffに任せる
          reportMissingImports = "error",
          reportUndefinedVariable = "error",
        },
      },
    },
    pyright = {
      disableOrganizeImports = true,  -- Ruffに任せる
    },
  },
}

return M