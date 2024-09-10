return {
  "gbprod/yanky.nvim",
  opts = {
   highlight = {
      on_put = true,
      on_yank = true,
      timer = 200,
    },
  },
  keys = require("mappings").yanky,
}

  -- dependencies = {
  --   { "kkharji/sqlite.lua" }
  -- },
