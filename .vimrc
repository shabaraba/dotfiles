"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('~/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
" Required:

" Add or remove your plugins here like this:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('cocopon/iceberg.vim')
call dein#add('markonm/traces.vim')

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"Personal Settings------------------------
set background=dark
colorscheme iceberg
"End Personal Settings--------------------

" setting --------------------------------
set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd


set number
set cursorline
set cursorcolumn
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
set shiftwidth=4


set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

:set encoding=utf-8
:set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8,shift_jis,cp932,ucs-bom

noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <C-n> <Down>
noremap! <C-p> <Up>
noremap! <C-a> <Home>
noremap! <C-e> <End>
noremap! <C-h> <Backspace>
noremap! <C-d> <Delete>

" end setting --------------------------------
