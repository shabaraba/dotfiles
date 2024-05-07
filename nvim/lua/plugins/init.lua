local vim = vim
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
                 -- "BufferLineTabClose",
                 -- "BufferlineBufferSelected",
                 -- "BufferLineFill",
                 -- "BufferLineBackground",
                 -- "BufferLineSeparator",
                 -- "BufferLineIndicatorSelected",
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
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      },
      config = override_req("neotree", "plugins.configs.neotree"),
      cmd = { "Neotree" },
      keys = require("mappings").neotree(),
    },
    {
        "feline-nvim/feline.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = override_req("feline", "plugins.configs.statusline"),
    },

    -- {
    --     "akinsho/bufferline.nvim",
    --     -- after = "nvim-web-devicons",
    --     config = override_req("bufferline", "plugins.configs.bufferline"),
    --     init = function()
    --         require("mappings").bufferline()
    --     end,
    -- },
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
            require("mappings").dashboard()
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        -- cmd = "Telescope",
        config = override_req("telescope", "plugins.configs.telescope"),
        init = function()
            require("mappings").telescope()
        end,
        dependnecies = {
            {'nvim-lua/plenary.nvim'},
            {'fannheyward/telescope-coc.nvim'},
            -- {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
        }
    },

   -- mql5
   {'rupurt/vim-mql5'},

   -- git
    {'airblade/vim-gitgutter'},
    {'tpope/vim-fugitive'},
    {'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim'},

   -- language server plotocol
   -- {
   --      'neoclide/coc.nvim',
   --      branch = "master",
   --      -- build = "yarn install --frozen-lockfile",
   --      build = ":call coc#util#install()",
   --      config = require('plugins.configs.coc').config(),
   -- },
   -- {
   --     'ldelossa/litee.nvim',
   --     init = function()
   --         require('litee.lib').setup({
   --             tree = {
   --                  icon_set = "codicons"
   --              },
   --              panel = {
   --                  orientation = "left",
   --                  panel_size  = 30
   --              }
   --         })
   --     end,
   -- },
   -- {
   --     'ldelossa/litee-calltree.nvim',
   --     init = function()
   --         require('litee.calltree').setup({})
   --     end,
   -- },

    -- lsp stuff
   {
       "williamboman/mason.nvim", -- LSP Installer
       dependencies = {
           "williamboman/mason-lspconfig.nvim",
           {
               "neovim/nvim-lspconfig",
               -- dependencies = { "hrsh7th/nvim-cmp" },
               dependencies = { "echasnovski/mini.completion", version = false },
               init = function()
                   require("mappings").lsp()
               end,
               config = function()
                   require('mini.completion').setup({})
                    -- 3. completion (hrsh7th/nvim-cmp)
                    -- local cmp = require("cmp")
                    -- cmp.setup({
                    --   snippet = {
                    --     expand = function(args)
                    --       vim.fn["vsnip#anonymous"](args.body)
                    --     end,
                    --   },
                    --   sources = {
                    --     { name = "nvim_lsp" },
                    --     -- { name = "buffer" },
                    --     -- { name = "path" },
                    --   },
                    --   mapping = cmp.mapping.preset.insert({
                    --     ["<C-p>"] = cmp.mapping.select_prev_item(),
                    --     ["<C-n>"] = cmp.mapping.select_next_item(),
                    --     ['<C-l>'] = cmp.mapping.complete(),
                    --     ['<C-e>'] = cmp.mapping.abort(),
                    --     ["<CR>"] = cmp.mapping.confirm { select = true },
                    --   }),
                    --   experimental = {
                    --     ghost_text = true,
                    --   },
                    -- })
                    -- config hover design
                    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                        vim.lsp.handlers.hover,
                        {
                            border = "single", -- "shadow" , "none", "rounded"
                            -- width = 100,
                        }
                    )
                    vim.cmd [[
                        " autocmd ColorScheme * highlight NormalFloat guifg=gray guibg=#073642
                        " autocmd ColorScheme * highlight FloatBorder guifg=gray guibg=#073642
                        autocmd ColorScheme * highlight! link FloatBorder NormalFloat
                    ]]
               end
           },
           "nvim-lua/plenary.nvim",
       },
       event = "VeryLazy",
       config = function()
           require "mason".setup {}
           local mason_lspconfig = require("mason-lspconfig")
           local on_attach = function(_, bufnr)
               vim.api.nvim_buf_set_option(bufnr, "formatexpr",
                   "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
               -- _G.lsp_onattach_func(i, bufnr)
           end
           mason_lspconfig.setup_handlers({
               function(server_name)
                   local opts = {
                       on_attach = on_attach,
                       settings = {
                           ["omniSharp"] = {
                               useGlobalMono = "always"
                           }
                       },
                   }
                   require("lspconfig")[server_name].setup(opts)
               end,
           })
           vim.cmd("LspStart") -- 初回起動時はBufEnterが発火しない
       end,
   },
   {
       "SmiteshP/nvim-navic",
       dependencies = {
           "neovim/nvim-lspconfig"
       },
       init = function()
           local navic = require("nvim-navic")
           require("lspconfig").clangd.setup {
               on_attach = function(client, bufnr)
                   navic.attach(client, bufnr)
               end
           }
       end,
   },
   {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
      config = override_req("nvim_treesitter", "plugins.configs.treesitter"),
   },
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',-- optional
            'nvim-tree/nvim-web-devicons',    -- optional
        },
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
        require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        })
        end
    },
   {
       -- 'easymotion/vim-easymotion',
       'phaazon/hop.nvim',
       branch = 'v2', -- optional but strongly recommended
       -- after = "nvim-base16.lua",
       config = function()
           -- require'plugins.configs.easy_motion'
           require'plugins.configs.hop'
       end
   },
   {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function() require'treesitter_indent_object.textobj'.select_indent_outer() end,
        mode = {"x", "o"},
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        function() require'treesitter_indent_object.textobj'.select_indent_outer(true) end,
        mode = {"x", "o"},
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        function() require'treesitter_indent_object.textobj'.select_indent_inner() end,
        mode = {"x", "o"},
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        function() require'treesitter_indent_object.textobj'.select_indent_inner(true, 'V') end,
        mode = {"x", "o"},
        desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
      },
    },
  },
--
})
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
