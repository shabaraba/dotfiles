require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }

local map = require'core.utils'.map
local g = vim.g
map('n', '<leader>s', '<cmd>HopChar2<CR>', {noremap = true, silent = false})
g.EasyMotion_keys = 'hgjfkdls'
