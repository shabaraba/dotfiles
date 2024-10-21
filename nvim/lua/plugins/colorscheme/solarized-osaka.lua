local vim = vim
return {
  "craftzdog/solarized-osaka.nvim",
  event = "VimEnter",
  -- priority = 1000,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    transparent = true,     -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "transparent",       -- style for sidebars, see below
      floats = "transparent",         -- style for floating windows
    },
    sidebars = { "qf", "help" },      -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = false,             -- dims inactive windows
    lualine_bold = false,             -- When `true`, section headers in the lualine theme will be bold

    on_colors = function(colors)
      -- colors.blue500 = colors.blue300
      -- colors.yellow500 = colors.yellow300
      -- colors.orange500 = colors.orange300
      -- colors.red500 = colors.red300
      -- colors.magenta500 = colors.magenta300
      -- colors.violet500 = colors.violet300
      -- colors.cyan500 = colors.cyan300
      -- colors.green500 = colors.green300
      -- colors.error = "#ff0000"
    end,

    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    on_highlights = function(highlights, colors)
      -- highlights.Function.fg = colors.blue300
      highlights.NeoTreeCursorLine = { bg = colors.base03 }
      highlights.MiniIndentscopeSymbol = { fg = colors.green300 }
      highlights.YankHighlight = { bg = "#553311" }
      vim.api.nvim_create_autocmd("TextYankPost", {
        pattern = "*",
        callback = function()
          vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 200 })
        end,
      })
    end
  },
  config = function()
    vim.cmd [[colorscheme solarized-osaka]]
  end
}
