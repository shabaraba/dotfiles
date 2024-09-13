-- improve neovim lsp experience
-- Breadcrumbs
-- Callhierarchy
-- Code Action
-- Definition
-- Diagnostic
-- Finder
-- Float Terminal
-- Hover
-- Implement
-- LightBulb
-- Outline
-- Rename
-- Ui Beacon

return {
  'nvimdev/lspsaga.nvim',
  -- cmd = { "LspSaga" },
  event = { "LspAttach" },
  keys = require("mappings").lspsaga,
  opts = {
    finder = {
      max_height = 0.6,
      default = 'tyd+ref+imp+def',
      keys = {
        toggle_or_open = '<CR>',
        vsplit = 'v',
        split = 's',
        tabnew = 't',
        tab = 'T',
        quit = 'q',
        close = '<Esc>',
      },
      methods = {
        tyd = 'textDocument/typeDefinition',
      }
    },
    outline = {
      win_position = "right",
      detail = false,
      keys = {
        toggle_or_jump = 'o',
        jump = '<CR>'
      }
    }
  }
}
