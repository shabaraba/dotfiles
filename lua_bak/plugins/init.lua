local packer
local function init()
  if not packer then
    packer = require'packer'
	packer.init { disable_commands = true }
  end
  local use = packer.use
  packer.reset()
	use '~/.local/share/nvim/site/pack/packer/opt/packer.nvim'

	use{
		'dbakker/vim-projectroot',
		config = function()
			vim.api.nvim_set_keymap('n', '<space>cdn', ':ProjectRootCD<CR>:NERDTreeCWd<CR>', {noremap = true, silent = true})
		end
	}

	use 'tpope/vim-surround'
	use{ 'thinca/vim-quickrun', }
	use{ 'tpope/vim-endwise', }
	use{ 'Townk/vim-autoclose', }
	use{ 'w0rp/ale', }
	use{ 'Shougo/neco-vim', }
	-- pug syntax highlighting
	use{ 'digitaltoad/vim-pug', }

	-- csv syntax highlight
	use{ 'mechatroner/rainbow_csv', }

	use{
		'nanndemoiikara/PDV--phpDocumentor-for-Vim',
		config = function()
			vim.g.pdv_cfg_Type = "mixed"
			vim.g.pdv_cfg_Package = ""
			vim.g.pdv_cfg_Version = "$id$"
			vim.g.pdv_cfg_Author = "Tanaka <tanaka@example.com>"
			vim.g.pdv_cfg_License = "Hoge Lisence"
			vim.api.nvim_set_keymap('i', '/**', '<ESC>j:call PhpDocSingle()<CR>', {noremap = false, silent = false})
		end,
	}

	-- language server plotocol
	-- use{
	-- 	'neoclide/coc.nvim',
	-- 	config = [[require('config.coc')]]
	-- }

	-- comment out
	use{
		'tpope/vim-commentary',
		config = function()
			vim.cmd('autocmd FileType python setlocal commentstring=# %s')
		end,
	}

	use{
		'skanehira/preview-markdown.vim',
		config = function()
			vim.g.preview_markdown_auto_update = 1
			vim.g.preview_markdown_vertical = 1
			vim.g.preview_markdown_parser = 'glow'
		end

	}

    use{
        'junegunn/fzf',
        run = './install --all',
    }

    use{
        'preservim/nerdtree',
        config = [[require('config.nerdtree')]],
        -- icon for NERDTREE
        requires = {
            {'ryanoasis/vim-devicons'}
        }
    }

    -- git
    use'airblade/vim-gitgutter'
    use'tpope/vim-fugitive'

    use {
        'APZelos/blamer.nvim',
        config = [[
            vim.g.blamer_enabled = 1
            vim.g.blamer_delay = 2000
        ]]
    }

    use{
        'bkad/CamelCaseMotion',
        config = [[require('config.camel_case_motion')]]
    }

    use{
        'easymotion/vim-easymotion',
        config = [[
            vim.api.nvim_set_keymap('n', '<leader>s', '<Plug>(easymotino-s2)', {noremap = false, silent = false})
            vim.g.EasyMotion_keys = 'hgjfkdls'
        ]]
    }

    -- DB
    use'tpope/vim-dadbod'
    use'pbogut/vim-dadbod-ssh'
    use'kristijanhusak/vim-dadbod-ui'

    -- api client
    -- use'baverman/vial'
    -- use'baverman/vial-http'

    -- visuals
    use{
        'machakann/vim-highlightedyank',
        config = [[
            vim.g.highlightedyank_highlight_duration = 200
        ]]
    }

    use{
        'lukas-reineke/indent-blankline.nvim',
        config = [[
            vim.g.space_char_blankline = " "
            vim.g.show_current_context = 1
            vim.g.show_current_context_start = 1
        ]]
    }

    -- status bar
    use{
        'majutsushi/tagbar',
        config = [[
            vim.g.tagbar_width = 30
            vim.g.tagbar_autoshowtag = 1
            vim.g.tagar_autofocus = 1
        ]]
    }

    use'vim-airline/vim-airline-themes'

    use{
        'vim-airline/vim-airline',
        config = [[require('config.airline')]]
    }

    use'sickill/vim-monokai'
    use'jacoborus/tender.vim'
end

return setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
end,
})
