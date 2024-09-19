local vim = vim

return {
  "cocopon/iceberg.vim",
  lazy = false,
  config = function()
    -- vim.cmd [[colorscheme iceberg]]
    -- Luaの場合
    vim.cmd [[
      hi Normal guibg=NONE ctermbg=NONE
      hi NormalNC guibg=NONE ctermbg=NONE
      hi NormalFloat guibg=NONE ctermbg=NONE
    ]]
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

    vim.api.nvim_set_hl(0, "ICEBERG_NORMAL_FG", { fg = "#c6c8d1" })
    vim.api.nvim_set_hl(0, "ICEBERG_BLUE500", { fg = "#515e97" })
    vim.api.nvim_set_hl(0, "ICEBERG_BLUE300", { fg = "#84a0c6" })
    vim.api.nvim_set_hl(0, "ICEBERG_BLUE100", { fg = "#a3adcb" })
    vim.api.nvim_set_hl(0, "ICEBERG_LIGHTBLUE", { fg = "#cdd1e6" })
    vim.api.nvim_set_hl(0, "ICEBERG_ORANGE", { fg = "#e4aa80" })
    vim.api.nvim_set_hl(0, "ICEBERG_DEEPBLUE", { fg = "#6b7089" })
    vim.api.nvim_set_hl(0, "ICEBERG_BLUEGREEN", { fg = "#89b8c2" })
    vim.api.nvim_set_hl(0, "ICEBERG_GREEN", { fg = "#b4be82" })
    vim.api.nvim_set_hl(0, "ICEBERG_COL", { fg = "#a093c7" })
    vim.api.nvim_set_hl(0, "ICEBERG_COL", { fg = "#444b71" })
    vim.api.nvim_set_hl(0, "ICEBERG_WHITE", { fg = "#d4d5db" })
    vim.api.nvim_set_hl(0, "ICEBERG_COL", { fg = "#818596" })
    vim.api.nvim_set_hl(0, "ICEBERG_RED", { fg = "#e27878" })

    vim.api.nvim_set_hl(0, "@property", { link = "ICEBERG_BLUE100" })
    vim.api.nvim_set_hl(0, "@keyword", { link = "ICEBERG_GREEN" })
  end
}
