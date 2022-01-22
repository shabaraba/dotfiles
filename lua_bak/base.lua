local api = vim.api

--Keys
vim.g.mapleader = ' '

vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', {noremap = true})
vim.api.nvim_set_keymap('n', '9', '$', {noremap = true})
vim.api.nvim_set_keymap('n', '}', '%', {noremap = true})
vim.api.nvim_set_keymap('n', '{', '%', {noremap = true})
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>', {noremap = false})
vim.api.nvim_set_keymap('n', '<C-b>', '<Left>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-f>', '<Right>', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', {noremap = true})

vim.api.nvim_set_keymap('n', '<C-j>', ':bp<CR>', {noremap = false})
vim.api.nvim_set_keymap('n', '<C-k>', ':bn<CR>', {noremap = false})

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true, silent = true})


--ウィンドウを閉じずにバッファを閉じる
vim.cmd('command! BD call EBufdelete()')
--[[
function! EBufdelete()
  currentBufNum = bufnr("%")
  alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum) then
    buffer #
  else
    bnext
  end
  if buflisted(l:currentBufNum) then
    execute "silent bwipeout"..currentBufNum
    --bwipeoutに失敗した場合はウインドウ上のバッファを復元
    if bufloaded(l:currentBufNum) != 0 then
      execute "buffer "..currentBufNum
    end
  end
end
]]
