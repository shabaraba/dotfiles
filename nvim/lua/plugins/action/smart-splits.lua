return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  opts = {
    ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
    ignored_filetypes = { 'NvimTree' },
    default_amount = 3,
    at_edge = 'wrap',
    multiplexer_integration = 'wezterm',
    disable_multiplexer_nav_when_zoomed = true,
  },
  keys = {
    { '<C-w>r', function()
        local ss = require('smart-splits')
        local map = { h = ss.resize_left, j = ss.resize_down, k = ss.resize_up, l = ss.resize_right }
        vim.notify('resize mode (hjkl / q,Esc to exit)', vim.log.levels.INFO)
        while true do
          local ok, ch = pcall(vim.fn.getchar)
          if not ok then break end
          local c = type(ch) == 'number' and vim.fn.nr2char(ch) or ch
          if c == '\27' or c == 'q' then break end
          if map[c] then map[c](); vim.cmd('redraw') end
        end
      end, mode = 'n', desc = 'Enter resize mode' },
    { '<C-w>h', function() require('smart-splits').move_cursor_left() end,  mode = 'n', desc = 'Move to left split/pane' },
    { '<C-w>j', function() require('smart-splits').move_cursor_down() end,  mode = 'n', desc = 'Move to below split/pane' },
    { '<C-w>k', function() require('smart-splits').move_cursor_up() end,    mode = 'n', desc = 'Move to above split/pane' },
    { '<C-w>l', function() require('smart-splits').move_cursor_right() end, mode = 'n', desc = 'Move to right split/pane' },
    { '<C-S-h>', function() require('smart-splits').move_cursor_left() end,  mode = 'n', desc = 'Move to left split/pane' },
    { '<C-S-j>', function() require('smart-splits').move_cursor_down() end,  mode = 'n', desc = 'Move to below split/pane' },
    { '<C-S-k>', function() require('smart-splits').move_cursor_up() end,    mode = 'n', desc = 'Move to above split/pane' },
    { '<C-S-l>', function() require('smart-splits').move_cursor_right() end, mode = 'n', desc = 'Move to right split/pane' },
  },
}
