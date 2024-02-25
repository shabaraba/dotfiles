local M = {}

-- vim.cmd( 'call coil398#init#coc#hook_source()')
--
M.config = function()
    vim.g.coc_global_extensions = {
        '@yaegassy/coc-volar',
        '@yaegassy/coc-intelephense',
        'coc-explorer',
        'coc-css',
        'coc-docker',
        'coc-eslint',
        'coc-git',
        'coc-html',
        'coc-json',
        -- 'coc-lua',
        'coc-markdownlint',
        'coc-prettier',
        'coc-sql',
        -- 'coc-sumneko-lua',
        'coc-toml',
        'coc-tsserver',
        'coc-vimlsp',
        -- 'coc-jedi',
        'coc-diagnostic',
        'coc-pyright',
        'coc-fzf-preview',
        'coc-phpls',
        -- 'coc-java'
    }
    -- vim.opt.statusline ^= "%{coc#status()}%{get(b:,'coc_current_function','')}"
    vim.g.coc_config_home = '~/dotfiles/.config/nvim/lua/plugins/configs'

    -- vim.cmd('autocmd FileType json syntax match Comment +//.+$+')
    vim.api.nvim_set_keymap('n', '<space><space>', ':<C-u>CocList<CR>', {noremap = false, silent = true})
    vim.api.nvim_set_keymap('n', '<space>h', ':<C-u>call CocAction("doHover")<CR>', {noremap = false, silent = true})
    vim.api.nvim_set_keymap('n', '<C-]>', '<Plug>(coc-definition)', {noremap = false, silent = true})
    vim.api.nvim_set_keymap('n', '<C-]><C-]>', '<Plug>(coc-references)', {noremap = false, silent = true})
    vim.api.nvim_set_keymap('n', '<space>rn', ':<Plug>(coc-rename)', {noremap = false, silent = true})
    -- pretter
    vim.api.nvim_create_user_command('Format', ':call CocActionAsync("format")', {})

    vim.api.nvim_set_keymap('n', '<Leader>f', '[fzf-p]', {noremap = false, silent = false})
    vim.api.nvim_set_keymap('x', '<Leader>f', '[fzf-p]', {noremap = false, silent = false})

    vim.api.nvim_set_keymap('n', '[fzf-p]pf', '<cmd>call CocAction("format")<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]f', '<cmd>CocCommand fzf-preview.FromResources project_mru git<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]af', '<cmd>CocCommand fzf-preview.MruFiles<CR>', {noremap = true, silent = true}) -- all files
    vim.api.nvim_set_keymap('n', '[fzf-p]gs', '<cmd>CocCommand fzf-preview.GitStatus<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]ga', '<cmd>CocCommand fzf-preview.GitActions<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]b', '<cmd>CocCommand fzf-preview.Buffers<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]B', '<cmd>CocCommand fzf-preview.AllBuffers<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]o', '<cmd>CocCommand fzf-preview.FromResources buffer project_mru<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]<C-o>', '<cmd>CocCommand fzf-preview.Jumps<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]g', '<cmd>CocCommand fzf-preview.Changes<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]/', '<cmd>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="\'"<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]*', '<cmd>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="\'<C-r>=expand(\'<cword>\')<CR>"<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]gr', ':CocCommand fzf-preview.ProjectGrep<Space>', {noremap = true, silent = true})
    -- vim.api.nvim_set_keymap('n', '[fzf-p]gr', 'sy:CocCommand fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, \'\n\', \'\', \'g\'), \'/\', \'\\/\', \'g\')<CR>"', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]t', '<cmd>CocCommand fzf-preview.BufferTags<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]q', '<cmd>CocCommand fzf-preview.QuickFix<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]l', '<cmd>CocCommand fzf-preview.LocationList<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]<C-]>', '<cmd>CocCommand fzf-preview.CocDefinition<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]<C-]><C-]>', '<cmd>CocCommand fzf-preview.CocReferences<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '[fzf-p]rf', '<cmd>CocCommand fzf-preview.DirectoryFiles<CR>', {noremap = true, silent = true})

    -- vim.cmd[[
    --     function! s:buffers_delete_from_paths(paths) abort
    --       for path in a:paths
    --         execute 'bdelete! ' . path
    --       endfor
    --     endfunction

    --     let g:buffer_delete_processor = {
    --     \ '':       function('fzf_preview#resource_processor#edit'),
    --     \ 'ctrl-s': function('fzf_preview#resource_processor#split'),
    --     \ 'ctrl-v': function('fzf_preview#resource_processor#vsplit'),
    --     \ 'ctrl-t': function('fzf_preview#resource_processor#vsplit'),
    --     \ 'ctrl-q': function('fzf_preview#resource_processor#export_quickfix'),
    --     \ 'ctrl-x': function('s:buffers_delete_from_paths'),
    --     \ }

    --     nnoremap <silent> <Leader>b :<C-u>call fzf_preview#resource_processor#set_processor_once(g:buffer_delete_processor)<CR>:FzfPreviewBuffers<CR> 
    -- ]]
    vim.cmd[[hi CocMenuSel guifg=#cccccc guibg=#2a3d75]]
end

return M
