return {
  "folke/noice.nvim",
  version = "4.4.7", -- 最新だとちらつくなど不具合が多いのでバージョン指定
  event = "VeryLazy",
  opts = {
    cmdline = {
      enabled = true,         -- enables the Noice cmdline UI
      view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = {},              -- global options for the cmdline. See section on views
      format = {
        -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
        -- view: (default is cmdline view)
        -- opts: any options passed to the view
        -- icon_hl_group: optional hl_group for the icon
        -- title: set to anything or empty string to hide
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
        -- lua = false, -- to disable a format, set to `false`
      },
    },
    messages = {
      enabled = false,
      view = "mini",               -- default view for messages
      view_error = "mini",         -- view for errors
      view_warn = "mini",          -- view for warnings
      view_history = "messages",   -- view for :messages
      view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    popupmenu = {
      enabled = true,  -- enables the Noice popupmenu UI
      backend = "nui", -- backend to use to show regular cmdline completions
      -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
      kind_icons = {}, -- set to `false` to disable icons
    },
    notify = {
      enabled = true,
      view = "mini",
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = false,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
    },
    -- routes = {
    --   {
    --     filter = {
    --       event = "msg_show",
    --       mode = "rm",           -- このモードのメッセージをフィルタリング
    --     },
    --     opts = { skip = false }, -- noice.nvimでのui.selectを無効化
    --   },
    -- },
    debug = false,
  },
  -- config = function()
  --   vim.lsp.signature.enabled = false
  -- end
}

-- dependencies = {
--   -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
--   "MunifTanjim/nui.nvim",
--   -- OPTIONAL:
--   --   `nvim-notify` is only needed, if you want to use the notification view.
--   --   If not available, we use `mini` as the fallback
--   "rcarriga/nvim-notify",
-- }
