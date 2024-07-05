return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = "BufRead",
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    })
  end
}


