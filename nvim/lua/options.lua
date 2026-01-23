local vim = vim
local opt = vim.opt
local g = vim.g

vim.cmd [[lang en_US.UTF-8]]

opt.title = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 0  -- コマンドラインを隠す
opt.laststatus = 0  -- ステータスラインを完全に非表示
opt.cul = true -- cursor line

opt.redrawtime = 10000
opt.encoding = 'utf-8'
opt.fileencodings = 'utf-8,euc-jp,sjis,shift_jis,cp932,ucs-bom,iso-2022-jp'

-- shell auto-detection
if vim.fn.executable('zsh') == 1 then
    opt.shell = 'zsh'
elseif vim.fn.executable('bash') == 1 then
    opt.shell = 'bash'
else
    opt.shell = 'sh'
end

opt.fileformats = "unix,dos,mac"
opt.backup = false
opt.swapfile = false
opt.autoread = true
opt.hidden = true
opt.showcmd = true
opt.wrap = false --行を折り返さない

-- Indentline

-- opt.list = true
-- opt.listchars:append "space:⋅"
opt.listchars:append "tab:>-,trail:_"

opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
opt.fillchars = { eob = " " }

opt.ignorecase = true
opt.smartcase = true
opt.mouse = ""

-- Numbers
opt.number = true
opt.numberwidth = 4
opt.relativenumber = true
opt.ruler = true

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 300

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

g.mapleader = " "

-- 日本語キーボード対応: ¥ を \ として扱う
vim.keymap.set({ "n", "v", "o" }, "¥", "\\", { remap = true })
vim.keymap.set("c", "¥", "\\", { remap = false })

-- Display line movement (for wrapped lines)
vim.keymap.set({ "n", "v" }, "j", "gj", { noremap = true, silent = true, desc = "Move down (display line)" })
vim.keymap.set({ "n", "v" }, "k", "gk", { noremap = true, silent = true, desc = "Move up (display line)" })
vim.keymap.set({ "n", "v" }, "gj", "j", { noremap = true, silent = true, desc = "Move down (logical line)" })
vim.keymap.set({ "n", "v" }, "gk", "k", { noremap = true, silent = true, desc = "Move up (logical line)" })
