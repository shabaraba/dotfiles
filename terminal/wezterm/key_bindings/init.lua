local workspace = require 'key_bindings.workspace'
local general = require 'key_bindings.general'
local tabs = require 'key_bindings.tabs'

local M = {}

function M.get_config()
  local keys = {}
  
  -- General bindings
  for _, key in ipairs(general.create_general_bindings()) do
    table.insert(keys, key)
  end
  
  -- Workspace bindings
  for _, key in ipairs(workspace.create_workspace_bindings()) do
    table.insert(keys, key)
  end
  
  -- Tab bindings
  for _, key in ipairs(tabs.create_tab_bindings()) do
    table.insert(keys, key)
  end
  
  return {
    leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
    keys = keys,
  }
end

return M