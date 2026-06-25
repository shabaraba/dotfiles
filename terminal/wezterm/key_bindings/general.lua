local wezterm = require 'wezterm'
local act = wezterm.action

local function is_vim(pane)
  local process = pane:get_foreground_process_name() or ''
  return process:find('n?vim$') ~= nil
end

local M = {}

function M.create_general_bindings()
  return {
    { key = 'h', mods = 'CMD', action = act.Hide },

    -- Pane add (split)
    { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER',       action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
    { key = 'd', mods = 'CMD',          action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'd', mods = 'CMD|SHIFT',    action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },

    -- Pane close
    { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = true } },
    { key = 'w', mods = 'ALT', action = act.CloseCurrentPane { confirm = true } },

    -- Pane zoom toggle
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

    -- Ctrl+Shift+hjkl: direct pane navigation (repeatable, no prefix needed)
    {
      key = 'H', mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(win, pane)
        if is_vim(pane) then
          win:perform_action(act.SendKey({ key = 'H', mods = 'CTRL|SHIFT' }), pane)
        else
          win:perform_action(act.ActivatePaneDirection 'Left', pane)
        end
      end),
    },
    {
      key = 'J', mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(win, pane)
        if is_vim(pane) then
          win:perform_action(act.SendKey({ key = 'J', mods = 'CTRL|SHIFT' }), pane)
        else
          win:perform_action(act.ActivatePaneDirection 'Down', pane)
        end
      end),
    },
    {
      key = 'K', mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(win, pane)
        if is_vim(pane) then
          win:perform_action(act.SendKey({ key = 'K', mods = 'CTRL|SHIFT' }), pane)
        else
          win:perform_action(act.ActivatePaneDirection 'Up', pane)
        end
      end),
    },
    {
      key = 'L', mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(win, pane)
        if is_vim(pane) then
          win:perform_action(act.SendKey({ key = 'L', mods = 'CTRL|SHIFT' }), pane)
        else
          win:perform_action(act.ActivatePaneDirection 'Right', pane)
        end
      end),
    },

    -- Ctrl+Shift+CMD+hjkl: enter resize mode (stay until Escape/q)
    { key = 'H', mods = 'CTRL|SHIFT|SUPER', action = act.Multiple {
        act.AdjustPaneSize { 'Left',  3 },
        act.ActivateKeyTable { name = 'pane_resize', one_shot = false, timeout_milliseconds = 1000 },
    }},
    { key = 'J', mods = 'CTRL|SHIFT|SUPER', action = act.Multiple {
        act.AdjustPaneSize { 'Down',  3 },
        act.ActivateKeyTable { name = 'pane_resize', one_shot = false, timeout_milliseconds = 1000 },
    }},
    { key = 'K', mods = 'CTRL|SHIFT|SUPER', action = act.Multiple {
        act.AdjustPaneSize { 'Up',    3 },
        act.ActivateKeyTable { name = 'pane_resize', one_shot = false, timeout_milliseconds = 1000 },
    }},
    { key = 'L', mods = 'CTRL|SHIFT|SUPER', action = act.Multiple {
        act.AdjustPaneSize { 'Right', 3 },
        act.ActivateKeyTable { name = 'pane_resize', one_shot = false, timeout_milliseconds = 1000 },
    }},

    -- Ctrl+w: pass through to nvim when active, else activate pane_nav key table
    {
      key = 'w', mods = 'CTRL',
      action = wezterm.action_callback(function(win, pane)
        if is_vim(pane) then
          win:perform_action(act.SendKey({ key = 'w', mods = 'CTRL' }), pane)
        else
          win:perform_action(
            act.ActivateKeyTable { name = 'pane_nav', one_shot = false, timeout_milliseconds = 1000 },
            pane
          )
        end
      end),
    },
  }
end

function M.get_key_tables()
  return {
    pane_nav = {
      { key = 'h', action = act.ActivatePaneDirection 'Left' },
      { key = 'j', action = act.ActivatePaneDirection 'Down' },
      { key = 'k', action = act.ActivatePaneDirection 'Up' },
      { key = 'l', action = act.ActivatePaneDirection 'Right' },
      { key = 'Escape', action = act.PopKeyTable },
      { key = 'q',      action = act.PopKeyTable },
    },
    pane_resize = {
      { key = 'h', action = act.AdjustPaneSize { 'Left',  3 } },
      { key = 'j', action = act.AdjustPaneSize { 'Down',  3 } },
      { key = 'k', action = act.AdjustPaneSize { 'Up',    3 } },
      { key = 'l', action = act.AdjustPaneSize { 'Right', 3 } },
      { key = 'H', action = act.AdjustPaneSize { 'Left',  3 } },
      { key = 'J', action = act.AdjustPaneSize { 'Down',  3 } },
      { key = 'K', action = act.AdjustPaneSize { 'Up',    3 } },
      { key = 'L', action = act.AdjustPaneSize { 'Right', 3 } },
      { key = 'Escape', action = act.PopKeyTable },
      { key = 'q',      action = act.PopKeyTable },
    },
  }
end

return M
