local vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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
  spec = {
    { import = "plugins.ui" },
    { import = "plugins.view" },
    { import = "plugins.action" },
    { import = "plugins.coding" },
    { import = "plugins.copilot" },
    { import = "plugins.core.lsp" },
    { import = "plugins.core.treesitter" },
    { import = "plugins.dependencies" },
  },
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  defaults = {
    lazy = true,
  },
  debug = false,
  opts = {
    rocks = {
      enabled = false
    }
  },
})

-- {
--     "akinsho/bufferline.nvim",
--     -- after = "nvim-web-devicons",
--     config = override_req("bufferline", "plugins.configs.bufferline"),
--     init = function()
--         require("mappings").bufferline()
--     end,
-- },

-- window resize
-- {
--     "simeji/winresizer",
--     config = function()
--         vim.g.winresizer_start_key = '<C-T>'
--     end
-- },
-- language server plotocol
-- {
--   'neoclide/coc.nvim',
--   branch = "master",
--   -- build = "yarn install --frozen-lockfile",
--   build = ":call coc#util#install()",
--   config = require('plugins.configs.coc').config(),
-- },
-- {
--   'ldelossa/litee.nvim',
--   init = function()
--     require('litee.lib').setup({
--       tree = {
--         icon_set = "codicons"
--       },
--       panel = {
--         orientation = "left",
--         panel_size  = 30
--       }
--     })
--   end,
-- },
-- {
--   'ldelossa/litee-calltree.nvim',
--   init = function()
--   require('litee.calltree').setup({})
--   end,
-- },
-- lsp stuff
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
-- # Neo-tree configuration has been updated. Please review the changes below.
