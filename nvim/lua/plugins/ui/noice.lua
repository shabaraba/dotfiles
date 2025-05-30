return {
  "folke/noice.nvim",
  -- version = "4.4.7", -- バージョン指定を削除して最新版を使用
  event = "VeryLazy",
  enabled = true, -- noice.nvimを有効化
  opts = {
    cmdline = {
      enabled = true,         -- enables the Noice cmdline UI
      view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = {
        border = {
          style = "rounded",
        },
      },              -- global options for the cmdline. See section on views
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
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing trigger characters
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
    },
    routes = {
      -- null-ls/none-ls関連のログをフィルタリング
      {
        filter = {
          event = "notify",
          find = "null%-ls",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "notify", 
          find = "none%-ls",
        },
        opts = { skip = true },
      },
      -- LSP関連の冗長なメッセージをフィルタリング
      {
        filter = {
          event = "notify",
          find = "eslint_d",
        },
        opts = { skip = true },
      },
      -- pile.nvim関連のログをフィルタリング
      {
        filter = {
          event = "notify",
          find = "pile",
        },
        opts = { skip = true },
      },
      -- SQL関連のログをフィルタリング
      {
        filter = {
          event = "notify",
          find = "SQL",
        },
        opts = { skip = true },
      },
      -- code_action関連のメッセージをフィルタリング
      {
        filter = {
          event = "notify",
          find = "code_action",
        },
        opts = { skip = true },
      },
      -- ✔ マークの付いたメッセージをフィルタリング
      {
        filter = {
          event = "notify",
          find = "✔",
        },
        opts = { skip = true },
      },
      -- 一般的なVimメッセージもフィルタリング
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
    },
    -- ビューの設定を追加
    views = {
      cmdline_popup = {
        position = {
          row = "40%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
    },
    debug = false,
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  }
}
