--  カラーテーマ指定してかっこよく
-- let g:airline_theme = 'badwolf'
vim.g.airline_theme = 'tender'
vim.g.airline_powerline_fonts = 1
vim.opt.laststatus=2
--  タブバーをかっこよく
vim.cmd([[g:airline#extensions#tabline#enabled = 1]])

--  gitのHEADから変更した行の+-を非表示(vim-gitgutterの拡張)
vim.cmd([[g:airline#extensions#hunks#enabled = 0]])
--  Lintツールによるエラー、警告を表示(ALEの拡張)
vim.cmd([[g:airline#extensions#ale#enabled = 1]])
vim.cmd([[g:airline#extensions#ale#error_symbol = 'E:']])
vim.cmd([[g:airline#extensions#ale#warning_symbol = 'W:']])
