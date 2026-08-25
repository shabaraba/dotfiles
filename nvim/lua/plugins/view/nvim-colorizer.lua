return {
  "NvChad/nvim-colorizer.lua",
  lazy = true,
  event = "BufRead", 
  config = function()
    require("colorizer").setup({
      -- "*" は全バッファをスキャンして重いため、色コードが登場するftに限定する
      filetypes = {
        "css", "scss", "sass", "html", "vue", "svelte",
        "javascript", "typescript", "javascriptreact", "typescriptreact",
        "lua", "vim", "yaml", "toml", "conf", "dosini", "markdown",
      },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
      buftypes = {},
    })
  end
}

