local map = require'core.utils'.map
local g = vim.g

map('n', '<leader>s', '<Plug>(easymotino-s2)', {noremap = true, silent = false})
g.EasyMotion_keys = 'hgjfkdls'
