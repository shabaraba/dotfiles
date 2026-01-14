return {
  "shabaraba/yozakura.nvim",
  lazy = false,
  dev = true,
  config = function()
    require("yozakura").setup({
      transparent = true,
      italic_comments = false,
      dim_inactive = false,
      palette = "teal_night",
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
      },
    })
    vim.cmd("colorscheme yozakura")
  end,
}
