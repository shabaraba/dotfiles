-- Settings module index
-- Aggregates all settings modules for easy import

local M = {}

-- Re-export all settings modules
M.window = require 'settings.window'
M.font = require 'settings.font'
M.colors = require 'settings.colors'

return M