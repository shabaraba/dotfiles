return {
  'dgagn/diagflow.nvim',
  event = 'LspAttach',
  opts = {
    enable = true,
    max_width = 60,  -- マックス幅
    severity_colors = {  -- 重要度に応じた色設定
        error = "DiagnosticFloatingError",
        warn = "DiagnosticFloatingWarn",
        info = "DiagnosticFloatingInfo",
        hint = "DiagnosticFloatingHint",
    },
    scope = "cursor",  -- 'cursor'または'line'
    placement = "top",  -- 'top'、'bottom'、または'inline'
  }
}
