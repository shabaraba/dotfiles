local vim = vim
return {
  "echasnovski/mini.completion",
  version = false,
  init = function()

    vim.cmd [[
      set updatetime=500
      highlight LspReferenceText  cterm=underline ctermbg=8 gui=underline guibg=#104040
      highlight LspReferenceRead  cterm=underline ctermbg=8 gui=underline guibg=#104040
      highlight LspReferenceWrite cterm=underline ctermbg=8 gui=underline guibg=#104040

      " augroup lsp_document_highlight
      "   autocmd! * <buffer>
      "   autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
      "   autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
      " augroup END
    ]]

    vim.diagnostic.config({
      virtual_text = false,
      hover = {border = "single"}, -- "shadow" , "none", "rounded"
    })
    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    --   vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
    -- )
    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    --   vim.lsp.handlers.hover,
    --   {
    --     border = "single", -- "shadow" , "none", "rounded"
    --     -- width = 100,
    --   }
    -- )
    vim.cmd [[
      " autocmd ColorScheme * highlight NormalFloat guifg=gray guibg=#073642
      " autocmd ColorScheme * highlight FloatBorder guifg=gray guibg=#073642
      autocmd ColorScheme * highlight! link FloatBorder NormalFloat
    ]]
  end,
  config = true,
  lazy = true,
  event = "BufRead",
}

