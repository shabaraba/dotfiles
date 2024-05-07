require'hop'.setup { keys = 'asertyuiohjkl' }

local map = require'core.utils'.map
local g = vim.g
map('n', 's', '<cmd>HopChar2<CR>', {noremap = true, silent = false})
