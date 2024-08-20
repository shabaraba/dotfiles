return {
  "gbprod/yanky.nvim",
  dependencies = {
    { "kkharji/sqlite.lua" }
  },
  opts = {
    -- ring = { storage = "sqlite" },
  },
  keys = require("mappings").yanky,
}
