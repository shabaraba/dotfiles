vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Skip some remote provider loading
vim.g.loaded_python_provider = 0
vim.g.python_host_prog = '/usr/bin/python2'
vim.g.python3_host_prog = '/usr/bin/python'
vim.g.node_host_prog = '/usr/bin/neovim-node-host'

local packer_dir = vim.fn.expand('~/.local/share/nvim/site/pack/packer/opt/packer.nvim')

if not (vim.fn.isdirectory(packer_dir) ~= 0) then
os.execute('git clone --depth 1 https://github.com/wbthomason/packer.nvim '..packer_dir)
end
if not string.match(vim.o.runtimepath, '/packer.nvim') then
  vim.o.runtimepath = packer_dir..','..vim.o.runtimepath
end

vim.cmd[[command! PackerInstall packadd packer.nvim | lua require'plugins'.install()]]
vim.cmd[[command! PackerUpdate packadd packer.nvim | lua require'plugins'.update()]]
vim.cmd[[command! PackerSync packadd packer.nvim | lua require'plugins'.sync()]]
vim.cmd[[command! PackerClean packadd packer.nvim | lua require'plugins'.clean()]]
vim.cmd[[command! PackerCompile packadd packer.nvim | lua require'plugins'.compile()]]

-- require('theme')
require('options')
require('base')

