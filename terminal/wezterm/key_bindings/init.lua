local workspace = require 'key_bindings.workspace'
local general = require 'key_bindings.general'
local tabs = require 'key_bindings.tabs'
local copy_mode = require 'key_bindings.copy_mode'

local M = {}

function M.get_config()
  local keys = {}

  for _, key in ipairs(general.create_general_bindings()) do
    table.insert(keys, key)
  end
  for _, key in ipairs(workspace.create_workspace_bindings()) do
    table.insert(keys, key)
  end
  for _, key in ipairs(tabs.create_tab_bindings()) do
    table.insert(keys, key)
  end

  local act = require('wezterm').action
  local key_tables = {
    copy_mode = copy_mode,
    search_mode = {
      { key = 'Enter',     mods = 'NONE', action = act.CopyMode 'AcceptPattern' },
      { key = 'Escape',    mods = 'NONE', action = act.CopyMode 'AcceptPattern' },
      { key = 'n',         mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p',         mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
      { key = 'r',         mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u',         mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
      { key = 'PageUp',    mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
      { key = 'PageDown',  mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
      { key = 'UpArrow',   mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    },
  }
  for name, bindings in pairs(general.get_key_tables()) do
    key_tables[name] = bindings
  end

  return {
    leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
    keys = keys,
    key_tables = key_tables,
  }
end

return M
