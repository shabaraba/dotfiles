" if (has("termguicolors"))
"  set termguicolors
" endif

" set background=dark
" colorscheme jellybeans
colorscheme monokai
" colorscheme iceberg
" colorscheme hybrid

" 背景透過
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
