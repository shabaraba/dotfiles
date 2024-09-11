return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    chunk = {
      enable = true,
      chars = {
        horizontal_line = "─",
        vertical_line = "│",
        left_top = "╭",
        left_bottom = "╰",
        right_arrow = ">",
      },
      style = "#00ffff",
    },
    indent = {
      enable = true,
      chars = {
        "│",
      },
    },
    blank = {
      enable = false,
      chars = {
        "⋅",
      },
    },
  }
}
