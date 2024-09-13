-- Visual Studio Code inspired breadcrumbs plugin for the Neovim editor

local vim = vim

return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- configurations go here
  },
  config = function()
    -- triggers CursorHold event faster
    vim.opt.updatetime = 200

    require("barbecue").setup({
      create_autocmd = false, -- prevent barbecue from updating itself automatically
    })

    vim.api.nvim_create_autocmd({
      "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",

      -- include this if you have set `show_modified` to `true`
      "BufModifiedSet",
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function()
        require("barbecue.ui").update()
      end,
    })
  end,
}

-- dependencies = {
--   "SmiteshP/nvim-navic",
--   "nvim-tree/nvim-web-devicons", -- optional dependency
-- },