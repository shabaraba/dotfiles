local M = {}

M.config = {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict",
        autoImportCompletions = true,
        diagnosticSeverityOverrides = {
          reportUnusedImport = "warning",
          reportMissingImports = "error",
          reportUndefinedVariable = "error",
        },
      },
    },
  },
}

return M