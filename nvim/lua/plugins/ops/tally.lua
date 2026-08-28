return {
  "shabaraba/tally.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("tally").early()
  end,
  opts = {
    passive = {
      "solarized%-osaka",
      "yozakura",
      "lush",
      "hlchunk",
      "nvim%-colorizer",
      "render%-markdown",
      "nvim%-web%-devicons",
      "mini%.icons",
      "lspkind",
      "plenary",
      "nui",
      "nvim%-treesitter",
      "diagflow",
      "nvim%-navic",
    },
  },
}
