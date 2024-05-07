" setting --------------------------------
set redrawtime=10000
set fenc=utf-8
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set nowrap "行を折り返さない

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
nnoremap 9 $
nnoremap } %
nnoremap { %
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

" ctags
set fileformats=unix,dos,mac
set fileencodings=utf-8,sjis

set tags=.tags;$HOME

function! s:execute_ctags() abort
  let tag_name = '.tags'
  let tags_path = findfile(tag_name, '.;')
  if tags_path ==# ''
    return
  endif

  let tags_dirpath = fnamemodify(tags_path, ':p:h')
  execute 'silent !cd' tags_dirpath '&& ctags -R -f' tag_name '2> /dev/null &'
endfunction

augroup ctags
  autocmd!
  autocmd BufWritePost * call s:execute_ctags()
augroup END

" ウィンドウを閉じずにバッファを閉じる
command! BD call EBufdelete()
function! EBufdelete()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if buflisted(l:currentBufNum)
    execute "silent bwipeout".l:currentBufNum
    " bwipeoutに失敗した場合はウインドウ上のバッファを復元
    if bufloaded(l:currentBufNum) != 0
      execute "buffer " . l:currentBufNum
    endif
  endif
endfunction
