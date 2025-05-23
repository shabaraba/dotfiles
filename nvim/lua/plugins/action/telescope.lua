return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  keys = require("mappings").telescope,
  opts = {
    pickers = {
      colorscheme = {
        enable_preview = true
      }
    },
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      -- file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      -- generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      -- file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      -- qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      -- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      },
      file_browser = {},
      -- coc = {
      --   theme = 'ivy',
      --   -- trueだと結果が1件でもTelescopeを経由する
      --   prefer_locations = false,
      -- }
    },
  },
  config = function(_, opts)
    local present, telescope = pcall(require, "telescope")
    if not present then
      return
    end
    
    -- Telescopeのactions
    local actions = require("telescope.actions")
    
    -- デフォルトのマッピングとマージ
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      mappings = {
        i = {
          ["<C-r>"] = actions.paste_register,  -- レジスタからペースト
          ["<C-v>"] = actions.paste_register,  -- システムクリップボードからペースト
        },
      },
    })
    
    telescope.setup(opts)
    
    local extensions = { "file_browser", "fzf", "frecency", "yank_history" }
    pcall(function()
      for _, ext in ipairs(extensions) do
        telescope.load_extension(ext)
      end
    end)
    
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  end,
}

-- dependencies = {
--   {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
--   {"nvim-telescope/telescope-file-browser.nvim"},
--   {"nvim-telescope/telescope-frecency.nvim"}
-- },
