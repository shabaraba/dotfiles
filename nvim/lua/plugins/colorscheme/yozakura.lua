return {
  -- dir = vim.fn.stdpath("config") .. "/lua/plugins/_developing/yozakura.nvim",
  "shabaraba/yozakura.nvim",
  lazy = false,
  dev = true,
  config = function()
    require("yozakura").setup({
      transparent = true,
      italic_comments = false,
      dim_inactive = false,
      palette = "night_blue",
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
