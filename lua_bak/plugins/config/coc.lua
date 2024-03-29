-- vim.cmd( 'call coil398#init#coc#hook_source()')
vim.g.coc_global_extensions = {
	'@yaegassy/coc-volar',
	'coc-css',
	'coc-docker',
	'coc-eslint',
	'coc-git',
	'coc-html',
	'coc-json',
	'coc-lua',
	'coc-markdownlint',
	'coc-phpls',
	'coc-prettier',
	'coc-sql',
	'coc-sumneko-lua',
	'coc-toml',
	'coc-tsserver',
	'coc-vimlsp',
	'coc-jedi',
	'coc-diagnostic',
	'coc-pyright',
	'coc-tabnine',
	'coc-fzf-preview',
}
-- vim.opt.statusline ^= "%{coc#status()}%{get(b:,'coc_current_function','')}"

-- vim.cmd('autocmd FileType json syntax match Comment +//.+$+')
vim.api.nvim_set_keymap('n', '<space><space>', ':<C-u>CocList<CR>', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<space>h', ':<C-u>call CocAction("doHover")<CR>', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<C-]>', '<Plug>(coc-definition)', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<C-]><C-]>', '<Plug>(coc-references)', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<space>rn', ':<Plug>(coc-rename)', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<A-S-f>', ':<Plug>(coc-format)', {noremap = false, silent = true})

vim.api.nvim_set_keymap('n', '<Leader>f', '[fzf-p]', {noremap = false, silent = false})
vim.api.nvim_set_keymap('x', '<Leader>f', '[fzf-p]', {noremap = false, silent = false})

vim.api.nvim_set_keymap('n', '[fzf-p]p', ':<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]af', ':<C-u>CocCommand fzf-preview.MruFiles<CR>', {noremap = true, silent = true}) -- all files
vim.api.nvim_set_keymap('n', '[fzf-p]gs', ':<C-u>CocCommand fzf-preview.GitStatus<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]ga', ':<C-u>CocCommand fzf-preview.GitActions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]b', ':<C-u>CocCommand fzf-preview.Buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]B', ':<C-u>CocCommand fzf-preview.AllBuffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]o', ':<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]<C-o>', ':<C-u>CocCommand fzf-preview.Jumps<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]g', ':<C-u>CocCommand fzf-preview.Changes<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]/', ':<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="\'"<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]*', ':<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="\'<C-r>=expand(\'<cword>\')<CR>"<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]gr', ':<C-u>CocCommand fzf-preview.ProjectGrep<Space>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]gr', 'sy:CocCommand fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, \'\n\', \'\', \'g\'), \'/\', \'\\/\', \'g\')<CR>"', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]t', ':<C-u>CocCommand fzf-preview.BufferTags<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]q', ':<C-u>CocCommand fzf-preview.QuickFix<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]l', ':<C-u>CocCommand fzf-preview.LocationList<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]<C-]>', ':<C-u>CocCommand fzf-preview.CocDefinition<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]<C-]><C-]>', ':<C-u>CocCommand fzf-preview.CocReferences<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[fzf-p]rf', ':<C-u>CocCommand fzf-preview.DirectoryFiles<CR>', {noremap = true, silent = true})
