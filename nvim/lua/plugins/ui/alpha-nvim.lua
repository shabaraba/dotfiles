return {
  'goolord/alpha-nvim',
  lazy = true,
  event = "VimEnter",
  config = function()
    local startify = require 'alpha.themes.startify'
    -- dashboard.section.buttons.val = {
    --   dashboard.button("e", "  New file", "<cmd>ene <CR>"),
    --   dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files <CR>"),
    --   dashboard.button("r", "󰊄  Recently opened files", "<cmd>Telescope frecency workspace=CWD theme=ivy <CR>"),
    --   dashboard.button("SPC f r", "  Frecency/MRU"),
    --   dashboard.button("SPC f g", "󰈬  Find word"),
    --   dashboard.button("SPC f m", "  Jump to bookmarks"),
    --   dashboard.button("SPC s l", "  Open last session"),
    -- }
    -- dashboard.section.footer.val = {
    --   "hello"
    -- }

    -- -- file_buttonの設定を変更
    -- local original_file_button = startify.file_button
    -- startify.file_button = function(...)
    --   local btn = original_file_button(...)
    --   btn.opts.position = "center"
    --   return btn
    -- end
    require 'alpha'.setup(startify.config)
  end
}

-- dependencies = {
--     'echasnovski/mini.icons',
--     'nvim-lua/plenary.nvim'
-- },
