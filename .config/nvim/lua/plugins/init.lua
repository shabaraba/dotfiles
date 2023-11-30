local plugin_settings = require("core.utils").load_config().plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local override_req = require("core.utils").override_req

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- "Nvchad/extensions",
    "nvim-lua/plenary.nvim",
    {
        "xiyaowong/nvim-transparent",
        dependencies = {'PHSix/nvim-hybrid',
            init = function()
                require('hybrid').setup()
            end
        },
        init = function()
         require("transparent").setup({
           extra_groups = { -- table/string: additional groups that should be clear
             -- In particular, when you set it to 'all', that means all avaliable groups

             -- example of akinsho/nvim-bufferline.lua
             "BufferLineTabClose",
             "BufferlineBufferSelected",
             "BufferLineFill",
             "BufferLineBackground",
             "BufferLineSeparator",
             "BufferLineIndicatorSelected",
           },
           exclude_groups = {}, -- table: groups you don't want to clear
         })
        end,
    },
    {
      "numToStr/Comment.nvim",
      opts = {},
      lazy = false,
    },
  -- file managing , picker etc
    {
         "nvim-tree/nvim-tree.lua",
         dependencies = { 'nvim-tree/nvim-web-devicons' },
         init = function()
            require("nvim-tree").setup()
         end,
         cmd = { "NvimTreeToggle", "NvimTreeFocus" },
         keys = require("core.mappings").nvimtree(),
    },
    {
        "feline-nvim/feline.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = override_req("feline", "plugins.configs.statusline"),
    },

    {
        "akinsho/bufferline.nvim",
        -- after = "nvim-web-devicons",
        config = override_req("bufferline", "plugins.configs.bufferline"),
        init = function()
            require("core.mappings").bufferline()
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufRead",
        config = override_req("indent_blankline", "(plugins.configs.others).blankline()"),
    },
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufRead",
        config = override_req("nvim_colorizer", "(plugins.configs.others).colorizer()"),
    },
    {
        'machakann/vim-highlightedyank',
        config = function()
            vim.g.highlightedyank_highlight_duration = 200
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = override_req("gitsigns", "(plugins.configs.others).gitsigns()"),
    },

    -- window resize
    -- {
    --     "simeji/winresizer",
    --     config = function()
    --         vim.g.winresizer_start_key = '<C-T>'
    --     end
    -- },
    {
        "windwp/nvim-autopairs",
        config = override_req("nvim_autopairs", "(plugins.configs.others).autopairs()"),
    },
    {
        "glepnir/dashboard-nvim",
        config = override_req("dashboard", "plugins.configs.dashboard"),
        init = function()
            require("core.mappings").dashboard()
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        -- cmd = "Telescope",
        config = override_req("telescope", "plugins.configs.telescope"),
        init = function()
            require("core.mappings").telescope()
        end,
        dependnecies = {
            {'nvim-lua/plenary.nvim'},
            -- {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
        }
    },
   -- git
    {'airblade/vim-gitgutter'},
    {'tpope/vim-fugitive'},
    {'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim'},

    -- language server plotocol
   {
        'neoclide/coc.nvim',
        branch = "master",
        -- build = "yarn install --frozen-lockfile",
        build = ":call coc#util#install()",
        config = require('plugins.configs.coc').config(),
   }

})
--    use {
--       "nvim-treesitter/nvim-treesitter",
--       event = "BufRead",
--       config = oconfigverride_req("nvim_treesitter", "plugins.configs.treesitter"),
--    }
--
-- --   -- lsp stuff
--
-- --    use {
-- --        "neovim/nvim-lspconfig",
-- --        opt = false,
-- --        setup = function()
-- --          --
-- --        end,
-- --        -- config = override_req("lspconfig", "plugins.configs.lspconfig"),
-- --        config = function()
-- --            -- require('lspconfig').intelephense.setup{}
-- --        end
-- --    }
--
-- --   use { 'williamboman/nvim-lsp-installer', }
--
-- --   use {
-- --      "ray-x/lsp_signature.nvim",
-- --      disable = not plugin_settings.status.lspsignature,
-- --      after = "nvim-lspconfig",
-- --      config = override_req("signature", "(plugins.configs.others).signature()"),
-- --   }
--
-- --   use {
-- --      "andymass/vim-matchup",
-- --      disable = not plugin_settings.status.vim_matchup,
-- --      opt = true,
-- --      setup = function()
-- --         require("core.utils").packer_lazy_load "vim-matchup"
-- --      end,
-- --   }
--
-- --   -- load luasnips + cmp related in insert mode only
--
-- --   use {
-- --      "rafamadriz/friendly-snippets",
-- --      disable = not plugin_settings.status.cmp,
-- --      event = "InsertEnter",
-- --   }
--
-- --   use {
-- --      "hrsh7th/nvim-cmp",
-- --      disable = not plugin_settings.status.cmp,
-- --      after = plugin_settings.options.cmp.lazy_load and "friendly-snippets",
-- --      config = override_req("nvim_cmp", "plugins.configs.cmp"),
-- --   }
--
-- --   -- use {
-- --   --    "L3MON4D3/LuaSnip",
-- --   --    disable = not plugin_settings.status.cmp,
-- --   --    wants = "friendly-snippets",
-- --   --    after = plugin_settings.options.cmp.lazy_load and "nvim-cmp",
-- --   --    config = override_req("luasnip", "(plugins.configs.others).luasnip()"),
-- --   -- }
--
-- --   -- use {
-- --   --    "saadparwaiz1/cmp_luasnip",
-- --   --    disable = not plugin_settings.status.cmp,
-- --   --    after = plugin_settings.options.cmp.lazy_load and "LuaSnip",
-- --   -- }
--
-- --   -- use {
-- --   --    "hrsh7th/cmp-nvim-lua",
-- --   --    disable = not plugin_settings.status.cmp,
-- --   --    after = plugin_settings.options.cmp.lazy_load and "cmp_luasnip",
-- --   -- }
--
-- --   -- use {
-- --   --    "hrsh7th/cmp-nvim-lsp",
-- --   --    disable = not plugin_settings.status.cmp,
-- --   --    after = plugin_settings.options.cmp.lazy_load and "cmp-nvim-lua",
-- --   -- }
--
-- --   -- use {
-- --   --    "hrsh7th/cmp-buffer",
-- --   --    disable = not plugin_settings.status.cmp,
-- --   --    after = plugin_settings.options.cmp.lazy_load and "cmp-nvim-lsp",
-- --   -- }
--
-- --   -- use {
-- --   --    "hrsh7th/cmp-path",
-- --   --    disable = not plugin_settings.status.cmp,
-- --   --    after = plugin_settings.options.cmp.lazy_load and "cmp-buffer",
-- --   -- }
--
-- --   -- load user defined plugins
-- --   -- require("core.customPlugins").run(use)
--
--   use 'tpope/vim-surround'
--   use 'thinca/vim-quickrun'
--   -- csv syntax highlight
--   use 'mechatroner/rainbow_csv'
--
--     use{
--         'skanehira/preview-markdown.vim',
--         config = function()
--             vim.g.preview_markdown_auto_update = 1
--             vim.g.preview_markdown_vertical = 1
--             vim.g.preview_markdown_parser = 'glow'
--         end
--     }
--
--    use{
--        'junegunn/fzf',
--        run = './install --all',
--    }
--
--    use{
--        -- 'easymotion/vim-easymotion',
--        'phaazon/hop.nvim',
--        branch = 'v1', -- optional but strongly recommended
--        -- after = "nvim-base16.lua",
--        config = function()
--            -- require'plugins.configs.easy_motion'
--            require'plugins.configs.hop'
--        end
--    }
--
--    use{
--        'bkad/CamelCaseMotion',
--        config = function()
--            require('plugins.configs.camel_case_motion')
--        end,
--    }
--
-- --    -- DB
-- --    use'tpope/vim-dadbod'
-- --    use'pbogut/vim-dadbod-ssh'
-- --    use'kristijanhusak/vim-dadbod-ui'
--
-- --    -- api client
-- --    -- use'baverman/vial'
-- --    -- use'baverman/vial-http'
--
--
--     use {
--         "rcarriga/nvim-dap-ui",
--         requires = {
--             "mfussenegger/nvim-dap",
--             {"Pocco81/dap-buddy.nvim", branch = 'dev'}
--         },
--         setup = function()
--            require'plugins.configs.dap'.setup()
--        end,
--        run = [[
--            git clone https://github.com/xdebug/vscode-php-debug.git ~/dotfiles/debugger/vscode-php-debug &&
--            cd ~/dotfiles/debugger/vscode-php-debug &&
--            npm install && npm run build
--        ]],
--        config = function()
--            require'plugins.configs.dap'.config()
--        end,
--    }
--
-- --	-- language server plotocol
--     use{
--         'neoclide/coc.nvim',
--         run = [[:call coc#util#install()]],
--         config = function()
--             require('plugins.configs.coc').config()
--         end
--     }
-- end)
