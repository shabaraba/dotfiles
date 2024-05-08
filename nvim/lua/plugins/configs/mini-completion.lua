local vim = vim
return {
  "echasnovski/mini.completion",
  version = false,
  init = function()
    require("mappings").lsp()
  end,
  config = function()
    require('mini.completion').setup({})
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover,
      {
        border = "single", -- "shadow" , "none", "rounded"
        -- width = 100,
      }
    )
    vim.cmd [[
      " autocmd ColorScheme * highlight NormalFloat guifg=gray guibg=#073642
      " autocmd ColorScheme * highlight FloatBorder guifg=gray guibg=#073642
      autocmd ColorScheme * highlight! link FloatBorder NormalFloat
    ]]
  end,
  lazy = true,
  event = "InsertEnter",
}

