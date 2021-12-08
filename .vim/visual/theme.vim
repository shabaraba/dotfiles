" if (has("termguicolors"))
"  set termguicolors
" endif

" set background=dark
" colorscheme jellybeans
colorscheme monokai
" colorscheme iceberg
" colorscheme hybrid

" 背景透過
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

augroup TransparentBG
    autocmd!
    autocmd Colorscheme * highlight Normal ctermbg=none
    autocmd Colorscheme * highlight NonText ctermbg=none
    autocmd Colorscheme * highlight LineNr ctermbg=none
    autocmd Colorscheme * highlight Folded ctermbg=none
    autocmd Colorscheme * highlight EndOfBuffer ctermbg=none 
augroup END

" let g:jellybeans_overrides = {
" \   'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
" \}
" if has('termguicolors') && &termguicolors
"     let g:jellybeans_overrides['background']['guibg'] = 'none'
" endif
