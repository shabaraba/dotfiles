return {
  "xiyaowong/nvim-transparent",
  event = "VimEnter",
  opts = {
    extra_groups = { -- table/string: additional groups that should be clear
      "VuffersWindowBackground",
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
  },
  config = function()
    vim.cmd [[
      hi Normal guibg=NONE ctermbg=NONE
      hi NormalNC guibg=NONE ctermbg=NONE
      hi NormalFloat guibg=NONE ctermbg=NONE
    ]]
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  end,

}


-- dependencies = {
--   'PHSix/nvim-hybrid',
--   init = function()
--     require('hybrid').setup()
--   end
-- },
