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
  event = { "LspAttach" },
  keys = require("mappings").lspsaga,
  dependencies = {
    "SmiteshP/nvim-navic",
  },
  config = function()
    require('lspsaga').setup({
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
        },
      },
      outline = {
        win_position = "right",
        detail = false,
        keys = {
          toggle_or_jump = 'o',
          jump = '<CR>'
        }
      },
      -- サーバー可用性チェックの改善
      beacon = {
        enable = false,
      },
      ui = {
        title = true,
        border = 'rounded',
        winblend = 0,
        expand = '',
        collapse = '',
        code_action = '💡',
        incoming = ' ',
        outgoing = ' ',
        hover = ' ',
      },
      hover = {
        max_width = 0.6,
        open_link = 'gx',
        open_cmd = '!open',
      },
      diagnostic = {
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        max_width = 0.7,
        custom_fix = nil,
        custom_msg = nil,
        text_hl_follow = false,
        border_follow = true,
        keys = {
          exec_action = 'o',
          quit = 'q',
        },
      },
      request_timeout = 3000,
    })
  end,
}
