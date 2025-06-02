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
  config = function(_, opts)
    require("transparent").setup(opts)
    
    -- 透過設定後にyozakuraの前景色を保持
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- 背景のみ透過、前景色は保持
        local highlights = {
          "Normal", "NormalNC", "NormalFloat", "SignColumn", "EndOfBuffer",
          "LineNr", "CursorLineNr", "Folded", "FoldColumn",
          "StatusLine", "StatusLineNC", "VertSplit"
        }
        
        for _, hl_name in ipairs(highlights) do
          local hl = vim.api.nvim_get_hl(0, { name = hl_name })
          if hl.fg then
            vim.api.nvim_set_hl(0, hl_name, { fg = hl.fg, bg = "NONE" })
          end
        end
        
        -- 特定の要素は半透明の背景を保持（視認性のため）
        local semi_transparent = {
          Visual = { bg = "#2e3145", blend = 50 },
          CursorLine = { bg = "#232334", blend = 30 },
          Pmenu = { bg = "#232334", blend = 85 },
          PmenuSel = { bg = "#3a3d55", blend = 85 },
          Search = { bg = "#f0b5d2", fg = "#1a1a26", blend = 30 },
          IncSearch = { bg = "#e8a5c8", fg = "#1a1a26", blend = 30 },
        }
        
        for hl_name, opts_hl in pairs(semi_transparent) do
          local hl = vim.api.nvim_get_hl(0, { name = hl_name })
          vim.api.nvim_set_hl(0, hl_name, vim.tbl_extend("force", hl, opts_hl))
        end
      end
    })
    
    -- 初回適用
    vim.cmd("doautocmd ColorScheme")
  end,

}


-- dependencies = {
--   'PHSix/nvim-hybrid',
--   init = function()
--     require('hybrid').setup()
--   end
-- },
