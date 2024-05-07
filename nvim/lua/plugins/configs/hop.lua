return {
  -- 'easymotion/vim-easymotion',
  'phaazon/hop.nvim',
  branch = 'v2', -- optional but strongly recommended
  -- after = "nvim-base16.lua",
  config = function()
    require'hop'.setup { keys = 'asertyuiohjkl' }

    local map = require'core.utils'.map
    local g = vim.g
    map('n', 's', '<cmd>HopChar2<CR>', {noremap = true, silent = false})
  end
}

