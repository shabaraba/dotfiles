local api = vim.api

vim.opt.redrawtime=10000

--" setting --------------------------------
vim.opt.redrawtime=10000
vim.opt.fenc='utf-8'
vim.opt.encoding='utf-8'
vim.opt.fileencodings='iso-2022-jp,euc-jp,sjis,utf-8'
vim.opt.fileformats="unix,dos,mac"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.showcmd = true
vim.opt.wrap = false --行を折り返さない

vim.opt.clipboard='unnamedplus'

vim.opt.number = true
vim.opt.cursorline = true
--vim.opt.cursorcolumn
vim.opt.virtualedit='onemore'
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.laststatus=2
vim.opt.wildmode="list:longest"

--Tab
vim.wo.listchars='tab:>-'
vim.opt.expandtab=false
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4

vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.incsearch=true
vim.opt.wrapscan=true
vim.opt.hlsearch=true

vim.opt.encoding='utf-8'
vim.opt.fileencodings='iso-2022-jp,euc-jp,sjis,utf-8,shift_jis,cp932,ucs-bom'
vim.opt.shell='zsh'

vim.opt.backspace='indent,eol,start'

vim.opt.fileformats='unix,dos,mac'
vim.opt.fileencodings='utf-8,sjis'

vim.opt.tags='.tags;$HOME'

