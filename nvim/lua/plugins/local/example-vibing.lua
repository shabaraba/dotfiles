-- Example: Override vibing.nvim configuration for this machine
-- Copy this file to 'vibing.lua' (remove 'example-' prefix) and customize
local M = require("plugins.ai.vibing");
M.opts.agent.default_model = "opus"
return M;
