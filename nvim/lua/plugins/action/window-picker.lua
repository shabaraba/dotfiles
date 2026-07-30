return {
  's1n7ax/nvim-window-picker',
  version = '2.*',
  keys = require('mappings').window_picker,
  opts = {
    hint = 'floating-big-letter',
    show_prompt = false,
    filter_rules = {
      include_current_win = false,
      autoselect_one = true,
      bo = {
        filetype = { 'notify', 'noice' },
        buftype = { 'terminal', 'quickfix' },
      },
    },
  },
}
