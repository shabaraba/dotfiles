return {
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require('everforest').setup({
    ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
    ---Default is "medium".
    background = "medium",
    ---How much of the background should be transparent. 2 will have more UI
    ---components be transparent (e.g. status line background)
    transparent_background_level = 0,
    ---Whether italics should be used for keywords and more.
    italics = true,
    ---Disable italic fonts for comments. Comments are in italics by default, set
    ---this to `true` to make them _not_ italic!
    disable_italic_comments = false,
    ---By default, the colour of the sign column background is the same as the as normal text
    ---background, but you can use a grey background by setting this to `"grey"`.
    sign_column_background = "none",
    ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
    ---`"low"` (default).
    ui_contrast = "low",
    dim_inactive_windows = false,
    diagnostic_text_highlight = false,
    diagnostic_virtual_text = "coloured",
    diagnostic_line_highlight = false,
    spell_foreground = false,
    show_eob = true,
    float_style = "bright",
    inlay_hints_background = "none",
    -- on_highlights = function(highlight_groups, palette) end,
    -- colours_override = function(palette) end,
  })
  end,
}
