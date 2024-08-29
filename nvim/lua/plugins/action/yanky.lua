return {
  "gbprod/yanky.nvim",
  dependencies = {
    { "kkharji/sqlite.lua" }
  },
  opts = {
   highlight = {
      on_put = true,
      on_yank = true,
      timer = 200,
    },
  },
  keys = require("mappings").yanky,
}
