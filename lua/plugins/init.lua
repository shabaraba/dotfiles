local plugin_settings = require("core.utils").load_config().plugins
local present, packer = pcall(require, plugin_settings.options.packer.init_file)

if not present then
   return false
end

local use = packer.use

return packer.startup(function()
   local override_req = require("core.utils").override_req

   -- this is arranged on the basis of when a plugin starts

   -- this is the nvchad core repo containing utilities for some features like theme swticher, no need to lazy load
    use "Nvchad/extensions"
    use "nvim-lua/plenary.nvim"


    use {
        "wbthomason/packer.nvim",
        event = "VimEnter",
    }

    -- highlightを上書きしている可能性があるので、highlightを使用するプラグインはこのプラグイン読み込み後に読み込む
   use {
      "NvChad/nvim-base16.lua",
      after = "packer.nvim",
      config = function()
         require("colors").init()
      end,
   }

   -- use {
   --   "xiyaowong/nvim-transparent",
   --   after = "nvim-base16.lua",
   --   config = function()
   --    require("transparent").setup({
   --      enable = true, -- boolean: enable transparent
   --      extra_groups = { -- table/string: additional groups that should be clear
   --        -- In particular, when you set it to 'all', that means all avaliable groups

   --        -- example of akinsho/nvim-bufferline.lua
   --        "BufferLineTabClose",
   --        "BufferlineBufferSelected",
   --        "BufferLineFill",
   --        "BufferLineBackground",
   --        "BufferLineSeparator",
   --        "BufferLineIndicatorSelected",
   --      },
   --      exclude = {}, -- table: groups you don't want to clear
   --    })
   --  end,
   -- }

   use {
      "kyazdani42/nvim-web-devicons",
      after = "nvim-base16.lua",
      config = override_req("nvim_web_devicons", "plugins.configs.icons"),
   }

   use {
      "feline-nvim/feline.nvim",
      disable = not plugin_settings.status.feline,
      after = "nvim-web-devicons",
      config = override_req("feline", "plugins.configs.statusline"),
   }

   use {
      "akinsho/bufferline.nvim",
      disable = not plugin_settings.status.bufferline,
      after = "nvim-web-devicons",
      config = override_req("bufferline", "plugins.configs.bufferline"),
      setup = function()
         require("core.mappings").bufferline()
      end,
   }

   use {
      "lukas-reineke/indent-blankline.nvim",
      disable = not plugin_settings.status.blankline,
      event = "BufRead",
      config = override_req("indent_blankline", "(plugins.configs.others).blankline()"),
   }

   use {
      "norcalli/nvim-colorizer.lua",
      disable = not plugin_settings.status.colorizer,
      event = "BufRead",
      config = override_req("nvim_colorizer", "(plugins.configs.others).colorizer()"),
   }

   use {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
      config = override_req("nvim_treesitter", "plugins.configs.treesitter"),
   }

   -- git stuff
   use {
      "lewis6991/gitsigns.nvim",
      disable = not plugin_settings.status.gitsigns,
      opt = true,
      config = override_req("gitsigns", "(plugins.configs.others).gitsigns()"),
      setup = function()
         require("core.utils").packer_lazy_load "gitsigns.nvim"
      end,
   }

   -- lsp stuff

    use {
        "neovim/nvim-lspconfig",
        opt = false,
        setup = function()
          --
        end,
        -- config = override_req("lspconfig", "plugins.configs.lspconfig"),
        config = function()
            -- require('lspconfig').intelephense.setup{}
        end
    }

   use { 'williamboman/nvim-lsp-installer', }

   use {
      "ray-x/lsp_signature.nvim",
      disable = not plugin_settings.status.lspsignature,
      after = "nvim-lspconfig",
      config = override_req("signature", "(plugins.configs.others).signature()"),
   }

   use {
      "andymass/vim-matchup",
      disable = not plugin_settings.status.vim_matchup,
      opt = true,
      setup = function()
         require("core.utils").packer_lazy_load "vim-matchup"
      end,
   }

   use {
      "max397574/better-escape.nvim",
      disable = not plugin_settings.status.better_escape,
      event = "InsertEnter",
      config = override_req("better_escape", "(plugins.configs.others).better_escape()"),
   }

   -- load luasnips + cmp related in insert mode only

   use {
      "rafamadriz/friendly-snippets",
      disable = not plugin_settings.status.cmp,
      event = "InsertEnter",
   }

   use {
      "hrsh7th/nvim-cmp",
      disable = not plugin_settings.status.cmp,
      after = plugin_settings.options.cmp.lazy_load and "friendly-snippets",
      config = override_req("nvim_cmp", "plugins.configs.cmp"),
   }

   use {
      "L3MON4D3/LuaSnip",
      disable = not plugin_settings.status.cmp,
      wants = "friendly-snippets",
      after = plugin_settings.options.cmp.lazy_load and "nvim-cmp",
      config = override_req("luasnip", "(plugins.configs.others).luasnip()"),
   }

   use {
       'tzachar/cmp-tabnine',
       run = './install.sh',
       after = plugin_settings.options.cmp.lazy_load and "nvim-cmp",
   }

   use {
      "saadparwaiz1/cmp_luasnip",
      disable = not plugin_settings.status.cmp,
      after = plugin_settings.options.cmp.lazy_load and "LuaSnip",
   }

   use {
      "hrsh7th/cmp-nvim-lua",
      disable = not plugin_settings.status.cmp,
      after = plugin_settings.options.cmp.lazy_load and "cmp_luasnip",
   }

   use {
      "hrsh7th/cmp-nvim-lsp",
      disable = not plugin_settings.status.cmp,
      after = plugin_settings.options.cmp.lazy_load and "cmp-nvim-lua",
   }

   use {
      "hrsh7th/cmp-buffer",
      disable = not plugin_settings.status.cmp,
      after = plugin_settings.options.cmp.lazy_load and "cmp-nvim-lsp",
   }

   use {
      "hrsh7th/cmp-path",
      disable = not plugin_settings.status.cmp,
      after = plugin_settings.options.cmp.lazy_load and "cmp-buffer",
   }
   -- misc plugins
   use {
      "windwp/nvim-autopairs",
      disable = not plugin_settings.status.autopairs,
      after = plugin_settings.options.cmp.lazy_load and plugin_settings.options.autopairs.loadAfter,
      config = override_req("nvim_autopairs", "(plugins.configs.others).autopairs()"),
   }

   use {
      "glepnir/dashboard-nvim",
      disable = not plugin_settings.status.dashboard,
      config = override_req("dashboard", "plugins.configs.dashboard"),
      setup = function()
         require("core.mappings").dashboard()
      end,
   }

   use {
      "numToStr/Comment.nvim",
      disable = not plugin_settings.status.comment,
      module = "Comment",
      config = override_req("nvim_comment", "(plugins.configs.others).comment()"),
      setup = function()
         require("core.mappings").comment()
     end,
   }

   -- file managing , picker etc
   use {
      "kyazdani42/nvim-tree.lua",
      disable = not plugin_settings.status.nvimtree,
      -- only set "after" if lazy load is disabled and vice versa for "cmd"
      after = not plugin_settings.options.nvimtree.lazy_load and "nvim-web-devicons",
      cmd = plugin_settings.options.nvimtree.lazy_load and { "NvimTreeToggle", "NvimTreeFocus" },
      config = override_req("nvim_tree", "plugins.configs.nvimtree"),
      setup = function()
         require("core.mappings").nvimtree()
      end,
   }

   -- use {
   --      "nvim-telescope/telescope.nvim",
   --      module = "telescope",
   --      cmd = "Telescope",
   --      config = override_req("telescope", "plugins.configs.telescope"),
   --      setup = function()
   --          require("core.mappings").telescope()
   --      end,
   --      requires = {
   --          {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
   --      }
   -- }

   -- load user defined plugins
   -- require("core.customPlugins").run(use)

   use 'tpope/vim-surround'
   use 'thinca/vim-quickrun'
   -- csv syntax highlight
   use 'mechatroner/rainbow_csv'

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

    -- git
    -- use'airblade/vim-gitgutter'
    use'tpope/vim-fugitive'

    -- use {
    --     'APZelos/blamer.nvim',
    --     config = [[
    --         vim.g.blamer_enabled = 1
    --         vim.g.blamer_delay = 2000
    --     ]]
    -- }

    use{
        -- 'easymotion/vim-easymotion',
        'phaazon/hop.nvim',
        branch = 'v1', -- optional but strongly recommended
        after = "nvim-base16.lua",
        config = function()
            -- require'plugins.configs.easy_motion'
            require'plugins.configs.hop'
        end
    }

    use{
        'bkad/CamelCaseMotion',
        config = function()
            require('plugins.configs.camel_case_motion')
        end,
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

    use {
        "rcarriga/nvim-dap-ui",
        requires = {
            "mfussenegger/nvim-dap",
            "Pocco81/DAPInstall.nvim"
        },
        setup = function()
            require'plugins.configs.dap'.setup()
        end,
        -- run = [[
        --     git clone https://github.com/xdebug/vscode-php-debug.git ~/dotfiles/debugger &&
        --     cd ~/dotfiles/debugger/vscode-php-debug &&
        --     npm install && npm run build
        -- ]],
        config = function()
            require'plugins.configs.dap'.config()
        end,
    }

	-- language server plotocol
	use{
		'neoclide/coc.nvim',
        run = [[:call coc#util#install()]],
		config = function()
            require('plugins.configs.coc').config()
        end
	}
end)
