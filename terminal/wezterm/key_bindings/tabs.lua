local wezterm = require 'wezterm'

local M = {}

function M.create_tab_bindings()
  return {
    -- 新しいタブを作成
    { key = 't', mods = 'CMD', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    -- タブを閉じる
    { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentTab { confirm = true } },
    -- 次のタブへ
    { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
    -- 前のタブへ
    { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
    -- タブを番号で選択
    { key = '1', mods = 'CMD', action = wezterm.action.ActivateTab(0) },
    { key = '2', mods = 'CMD', action = wezterm.action.ActivateTab(1) },
    { key = '3', mods = 'CMD', action = wezterm.action.ActivateTab(2) },
    { key = '4', mods = 'CMD', action = wezterm.action.ActivateTab(3) },
    { key = '5', mods = 'CMD', action = wezterm.action.ActivateTab(4) },
    { key = '6', mods = 'CMD', action = wezterm.action.ActivateTab(5) },
    { key = '7', mods = 'CMD', action = wezterm.action.ActivateTab(6) },
    { key = '8', mods = 'CMD', action = wezterm.action.ActivateTab(7) },
    { key = '9', mods = 'CMD', action = wezterm.action.ActivateTab(-1) }, -- 最後のタブ
  }
end

return M