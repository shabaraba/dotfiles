-- return {
--   dir = vim.fn.stdpath("config") .. "/lua/plugins/_developing/yozakura.nvim",
--   name = "yozakura.nvim",
--   lazy = false,
--   opts = {
--     transparent = false,
--     italic_comments = false,
--     dim_inactive = false,
--     palette = "night_blue", -- "soft_contrast" | "warm_gray" | "muted_rose" | "night_blue"
--     styles = {
--       comments = { italic = true },
--       keywords = { italic = false },
--       functions = { italic = false },
--       variables = { italic = false },
--     },
--   },
--   -- config = function()
--   --   -- カラースキームを適用する場合は以下のコメントを解除
--   --   vim.cmd("colorscheme yozakura")
--   -- end,
-- }

return {
  dir = vim.fn.stdpath("config") .. "/lua/plugins/_developing/yozakura.nvim",
  name = "yozakura.nvim",
  lazy = false,
  config = function()
    require("yozakura").setup({
      transparent = false,
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
