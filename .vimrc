" runtimepathを正す
if has("mac")
else
    let $VIMRUNTIME="/usr/local/share/nvim/runtime"
    set runtimepath+=/usr/local/share/nvim/runtime
endif

source ~/.vim/init/*.vim

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let g:dein#install_github_api_token = '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'
" source ~/.vim/dein_github_api_token.vim

" Required:
call dein#begin('~/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#load_toml('~/.vim/dein.toml', {'lazy': 0})
call dein#load_toml('~/.vim/dein_lazy.toml', {'lazy': 1})

call dein#load_toml('~/.vim/plugins/coding.toml', {'lazy': 0})
call dein#load_toml('~/.vim/plugins/database.toml', {'lazy': 0})

" Add or remove your plugins here like this:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('markonm/traces.vim')

" color theme
call dein#add('cocopon/iceberg.vim')

" Required:
call dein#end()

" Required:
filetype plugin indent on
" syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------
        
source ~/.vim/visual/*.vim
