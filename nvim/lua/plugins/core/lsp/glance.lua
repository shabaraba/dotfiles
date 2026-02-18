-- VSCode-like peek preview for LSP locations
-- Replaces Lspsaga finder for better jdtls compatibility
return {
  'dnlhc/glance.nvim',
  event = 'LspAttach',
  config = function()
    local glance = require('glance')
    local actions = glance.actions

    -- キーマップ登録
    vim.keymap.set('n', 'gd', '<CMD>Glance definitions<CR>', { desc = 'Glance definitions' })
    vim.keymap.set('n', 'gr', '<CMD>Glance references<CR>', { desc = 'Glance references' })
    vim.keymap.set('n', 'gi', '<CMD>Glance implementations<CR>', { desc = 'Glance implementations' })

    glance.setup({
      height = 18,
      zindex = 45,
      detached = function(winid)
        return vim.api.nvim_win_get_width(winid) < 100
      end,
      preview_win_opts = {
        cursorline = true,
        number = true,
        wrap = true,
      },
      border = {
        enable = true,
        top_char = '―',
        bottom_char = '―',
      },
      list = {
        position = 'right',
        width = 0.33,
      },
      theme = {
        enable = true,
        mode = 'auto',
      },
      mappings = {
        list = {
          ['j'] = actions.next,
          ['k'] = actions.previous,
          ['<Down>'] = actions.next,
          ['<Up>'] = actions.previous,
          ['<Tab>'] = actions.next_location,
          ['<S-Tab>'] = actions.previous_location,
          ['<C-u>'] = actions.preview_scroll_win(5),
          ['<C-d>'] = actions.preview_scroll_win(-5),
          ['v'] = actions.jump_vsplit,
          ['s'] = actions.jump_split,
          ['t'] = actions.jump_tab,
          ['<CR>'] = actions.jump,
          ['o'] = actions.jump,
          ['l'] = actions.open_fold,
          ['h'] = actions.close_fold,
          ['<leader>l'] = actions.enter_win('preview'),
          ['q'] = actions.close,
          ['Q'] = actions.close,
          ['<Esc>'] = actions.close,
        },
        preview = {
          ['Q'] = actions.close,
          ['<Tab>'] = actions.next_location,
          ['<S-Tab>'] = actions.previous_location,
          ['<leader>l'] = actions.enter_win('list'),
        },
      },
      hooks = {
        before_open = function(results, open, jump, method)
          if #results == 1 then
            jump(results[1])
          else
            open(results)
          end
        end,
      },
      folds = {
        fold_closed = '',
        fold_open = '',
        folded = true,
      },
      indent_lines = {
        enable = true,
        icon = '│',
      },
      winbar = {
        enable = true,
      },
    })
  end,
}
