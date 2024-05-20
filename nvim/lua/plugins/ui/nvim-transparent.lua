return {
  "xiyaowong/nvim-transparent",
  dependencies = {
    'PHSix/nvim-hybrid',
    init = function()
      require('hybrid').setup()
    end
  },
  config = true,
  event = "VimEnter",
  opts = {
    extra_groups = { -- table/string: additional groups that should be clear
      -- In particular, when you set it to 'all', that means all avaliable groups

      -- example of akinsho/nvim-bufferline.lua
      -- "BufferLineTabClose",
      -- "BufferlineBufferSelected",
      -- "BufferLineFill",
      -- "BufferLineBackground",
      -- "BufferLineSeparator",
      -- "BufferLineIndicatorSelected",
    },
    exclude_groups = {}, -- table: groups you don't want to clear
  }
}

