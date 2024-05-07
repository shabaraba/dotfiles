-- uncomment this if you want to open nvim with a dir
-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
-- vim.cmd[[ au InsertEnter * set norelativenumber ]]
-- vim.cmd[[ au InsertLeave * set relativenumber ]]

-- Don't show any numbers inside terminals
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Don't show status line on certain windows
vim.cmd [[ autocmd BufEnter,BufRead,BufWinEnter,FileType,WinEnter * lua require("core.utils").hide_statusline() ]]

-- Open a file from its last left off position
-- vim.cmd [[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
-- File extension specific tabbing
vim.cmd [[ 
   augroup filetypes
     autocmd Filetype python          setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 
     autocmd Filetype lua             setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2 
     autocmd Filetype javascript      setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
     autocmd Filetype typescript      setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
     autocmd Filetype typescriptreact setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
    augroup END
]]
