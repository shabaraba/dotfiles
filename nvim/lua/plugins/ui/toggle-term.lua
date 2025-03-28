return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    --[[ things you want to change go here]]
  },
  cmd = "ToggleTerm",
  keys = require("mappings").toggleTerm,

}
