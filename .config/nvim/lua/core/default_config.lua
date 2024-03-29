-- IMPORTANT NOTE : This is default config, so dont change anything here.
-- use custom/chadrc.lua instead

local M = {}

M.options = {
   -- custom = {}
   -- general nvim/vim options , check :h optionname to know more about an option

   clipboard = "unnamedplus",
   cmdheight = 1,
   ruler = true,
   hidden = true,
   ignorecase = true,
   smartcase = true,
   mapleader = " ",
   mouse = "",
   number = true,
   numberwidth = 4,
   relativenumber = false,
   expandtab = true,
   shiftwidth = 4,
   smartindent = true,
   tabstop = 4,
   timeoutlen = 300,
   updatetime = 300,
   undofile = true,
   fillchars = { eob = " " },

   -- NvChad options
   nvChad = {
      copy_cut = true, -- copy cut text ( x key ), visual and normal mode
      copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
      insert_nav = true, -- navigation in insertmode
      window_nav = true,

      -- updater
      update_url = "https://github.com/NvChad/NvChad",
      update_branch = "main",
   },
}

---- UI -----

M.ui = {
   hl_override = "", -- path of your file that contains highlights
   italic_comments = true,
   theme = "everforest", -- default theme

   -- Change terminal bg to nvim theme's bg color so it'll match well
   -- For Ex : if you have onedark set in nvchad, set onedark's bg color on your terminal
   transparency = true,
}

---- PLUGIN OPTIONS ----

M.plugins = {
   -- enable/disable plugins (false for disable)
   status = {
      blankline = true, -- indentline stuff
      bufferline = true, -- manage and preview opened buffers
      colorizer = true, -- color RGB, HEX, CSS, NAME color codes
      comment = true, -- easily (un)comment code, language aware
      dashboard = true,
      better_escape = true, -- map to <ESC> with no lag
      feline = true, -- statusline
      gitsigns = true,
      lspsignature = true, -- lsp enhancements
      vim_matchup = true, -- improved matchit
      cmp = true,
      nvimtree = true,
      autopairs = true,
   },
   options = {
      packer = {
         init_file = "plugins.packerInit",
      },
      autopairs = { loadAfter = "nvim-cmp" },
      cmp = {
         lazy_load = true,
      },
      lspconfig = {
         setup_lspconf = "", -- path of file containing setups of different lsps
      },
      nvimtree = {
         enable_git = 0,
         -- packerCompile required after changing lazy_load
         lazy_load = true,

         ui = {
            allow_resize = true,
            side = "left",
            width = 25,
            hide_root_folder = true,
         },
      },
      luasnip = {
         snippet_path = {},
      },
      statusline = {
         -- hide, show on specific filetypes
         hidden = {
            "help",
            "dashboard",
            "NvimTree",
            "terminal",
         },
         shown = {},

         -- truncate statusline on small screens
         shortline = true,
         style = "arrow", -- default, round , slant , block , arrow
      },
      esc_insertmode_timeout = 300,
   },
   default_plugin_config_replace = {},
}

-- Don't use a single keymap twice

--- MAPPINGS ----

-- non plugin
M.mappings = {
   -- custom = {}, -- custom user mappings

   misc = {
      cheatsheet = "<leader>ch",
      close_buffer = "<leader>x",
      copy_whole_file = "<C-a>", -- copy all contents of current buffer
      line_number_toggle = "<leader>n", -- toggle line number
      update_nvchad = "<leader>uu",
      new_buffer = "<S-t>",
      new_tab = "<C-t>b",
      save_file = "<C-s>", -- save file using :w
   },

   -- navigation in insert mode, only if enabled in options

   insert_nav = {
      backward = "<C-h>",
      end_of_line = "<C-e>",
      forward = "<C-l>",
      next_line = "<C-k>",
      prev_line = "<C-j>",
      beginning_of_line = "<C-a>",
   },

   -- better window movement
   window_nav = {
      moveLeft = "<C-h>",
      moveRight = "<C-l>",
      moveUp = "<C-k>",
      moveDown = "<C-j>",
   },

   -- terminal related mappings
   terminal = {
      -- multiple mappings can be given for esc_termmode, esc_hide_termmode

      -- get out of terminal mode
      esc_termmode = { "jk" },

      -- get out of terminal mode and hide it
      esc_hide_termmode = { "JK" },
      -- show & recover hidden terminal buffers in a telescope picker
      pick_term = "<leader>W",

      -- spawn terminals
      new_horizontal = "<leader>hterm",
      new_vertical = "<leader>vterm",
      new_window = "<leader>w",
   },
}

-- plugins related mappings

M.mappings.plugins = {
   bufferline = {
      next_buffer = "<C-k>",
      prev_buffer = "<C-j>",
   },
   comment = {
      toggle = "<leader>/",
   },

   dashboard = {
      bookmarks = "<leader>bm",
      -- new_file = "<leader>fn", -- basically create a new buffer
      -- open = "<leader>db", -- open dashboard
      session_load = "<leader>wl",
      session_save = "<leader>ws",
   },

   -- map to <ESC> with no lag
   better_escape = { -- <ESC> will still work
      esc_insertmode = { "jk" }, -- multiple mappings allowed
   },

   lspconfig = {
      declaration = "gD",
      definition = "<C-]>",
      hover = "<leader>h",
      implementation = "gi",
      signature_help = "gk",
      add_workspace_folder = "<leader>wa",
      remove_workspace_folder = "<leader>wr",
      list_workspace_folders = "<leader>wl",
      type_definition = "<leader>D",
      rename = "<leader>rn",
      code_action = "<leader>ca",
      references = "<C-]><C-]>",
      float_diagnostics = "ge",
      goto_prev = "[d",
      goto_next = "]d",
      set_loclist = "<leader>q",
      formatting = "<leader>fm",
   },

   nvimtree = {
      toggle = "<leader>b",
      focus = "<leader>e",
   },

   telescope = {
      buffers = "<leader>fb",
      find_files = "<leader>ff",
      find_hiddenfiles = "<leader>fa",
      git_commits = "<leader>cm",
      git_status = "<leader>gt",
      help_tags = "<leader>fh",
      live_grep = "<leader>fw",
      oldfiles = "<leader>fo",
      themes = "<leader>th", -- NvChad theme picker
   },
}

return M
