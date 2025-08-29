local wezterm = require 'wezterm'

local M = {}

function M.create_general_bindings()
  return {
    { key = "w", mods = "ALT", action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    { key = 'h', mods = 'CMD', action = wezterm.action.Hide },
    
    -- Pane navigation with leader + hjkl
    { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
    
    -- Split panes
    { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  }
end

return M
