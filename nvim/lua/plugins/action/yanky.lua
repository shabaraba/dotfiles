return {
  "gbprod/yanky.nvim",
  opts = {
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 200,
    },
    preserve_cursor_position = {
      enabled = true,
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    ring = {
      storage = "memory",
    },
    picker = {
      select = {
        action = nil, -- use default put action
      },
    },
    options = {
      preserve_register = true, -- ビジュアルモードでテキストを選択してペーストする際に、置換されたテキストが自動的にヤンクされることを防ぎます。
    },
  },
  keys = require("mappings").yanky,
}

-- dependencies = {
--   { "kkharji/sqlite.lua" }
-- },
