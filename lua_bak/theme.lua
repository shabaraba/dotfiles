vim.colorscheme = 'monokai'

--背景透過
vim.cmd([[highlight Normal ctermbg=NONE guibg=NONE]])
vim.cmd([[highlight NonText ctermbg=NONE guibg=NONE]])
vim.cmd([[highlight LineNr ctermbg=NONE guibg=NONE]])
vim.cmd([[highlight Folded ctermbg=NONE guibg=NONE]])
vim.cmd([[highlight EndOfBuffer ctermbg=NONE guibg=NONE]])

vim.cmd([[augroup TransparentBG
    autocmd!
    autocmd Colorscheme * highlight Normal ctermbg=none
    autocmd Colorscheme * highlight NonText ctermbg=none
    autocmd Colorscheme * highlight LineNr ctermbg=none
    autocmd Colorscheme * highlight Folded ctermbg=none
    autocmd Colorscheme * highlight EndOfBuffer ctermbg=none 
augroup END]])

