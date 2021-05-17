" setting --------------------------------
set fenc=utf-8
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set clipboard=unnamedplus

set number
set cursorline
"set cursorcolumn
set virtualedit=onemore
set smartindent
set showmatch
set laststatus=2
set wildmode=list:longest
nnoremap j gj
nnoremap k gk


" Tab
set list listchars=tab:\>\-
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4


set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8,shift_jis,cp932,ucs-bom
set shell=zsh

" Keys
let mapleader = "\<Space>"
inoremap jj <Esc>
nmap <Esc><Esc> :nohlsearch<CR><Esc>
noremap! <C-b> <Left>
noremap! <C-f> <Right>
"noremap! <C-n> <Down>
"noremap! <C-p> <Up>
noremap! <C-a> <Home>
noremap! <C-e> <End>
if has('nvim')
    " for tab
    command! -nargs=* T split | terminal <args>
    command! -nargs=* TV vsplit | terminal <args>
    tnoremap <silent> <ESC> <C-\><C-n>
    nmap <A-}> :tabn<CR>
    nmap <A-{> :tabp<CR>
    nmap <A-w> :tabc<CR>

    " for buffer
    nmap <C-j> :bp<CR>
    nmap <C-k> :bn<CR>
endif
set backspace=indent,eol,start
