local opt = vim.opt
local g = vim.g

local options = require("core.utils").load_config().options

vim.cmd[[lang en_US.UTF-8]]

opt.title = true
opt.clipboard = options.clipboard
opt.cmdheight = options.cmdheight
opt.cul = true -- cursor line

vim.opt.redrawtime=10000
vim.opt.encoding='utf-8'
vim.opt.fileencodings='utf-8,euc-jp,sjis,shift_jis,cp932,ucs-bom,iso-2022-jp'
vim.opt.shell = 'zsh'

vim.opt.fileformats="unix,dos,mac"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.showcmd = true
vim.opt.wrap = false --行を折り返さない

vim.opt.clipboard='unnamedplus'

-- Indentline

vim.cmd[[set list listchars=tab:\>\-,trail:_]]

opt.expandtab = options.expandtab
opt.shiftwidth = options.shiftwidth
opt.smartindent = options.smartindent

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
opt.fillchars = options.fillchars

opt.hidden = options.hidden
opt.ignorecase = options.ignorecase
opt.smartcase = options.smartcase
opt.mouse = options.mouse

-- Numbers
opt.number = options.number
opt.numberwidth = options.numberwidth
opt.relativenumber = options.relativenumber
opt.ruler = options.ruler

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.tabstop = options.tabstop
opt.termguicolors = true
opt.timeoutlen = options.timeoutlen
opt.undofile = options.undofile

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = options.updatetime

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

g.mapleader = options.mapleader

-- disable some builtin vim plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end

--背景透過
-- vim.cmd([[highlight Normal ctermbg=NONE guibg=NONE]])
-- vim.cmd([[highlight NonText ctermbg=NONE guibg=NONE]])
-- vim.cmd([[highlight LineNr ctermbg=NONE guibg=NONE]])
-- vim.cmd([[highlight Folded ctermbg=NONE guibg=NONE]])
-- vim.cmd([[highlight EndOfBuffer ctermbg=NONE guibg=NONE]])

-- vim.cmd([[augroup TransparentBG
--     autocmd!
--     autocmd Colorscheme * highlight Normal ctermbg=none
--     autocmd Colorscheme * highlight NonText ctermbg=none
--     autocmd Colorscheme * highlight LineNr ctermbg=none
--     autocmd Colorscheme * highlight Folded ctermbg=none
--     autocmd Colorscheme * highlight EndOfBuffer ctermbg=none 
-- augroup END]])

vim.cmd([[
    augroup filetypes
        autocmd! 
        autocmd Filetype javascript      setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
        autocmd Filetype typescript      setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
        autocmd Filetype typescriptreact setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
    augroup END
]])
