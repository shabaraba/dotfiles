local wezterm = require 'wezterm'

local M = {}

function M.create_general_bindings()
  return {
    { key = "w", mods = "ALT", action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    { key = 'h', mods = 'CMD', action = wezterm.action.Hide },
  }
end

return M