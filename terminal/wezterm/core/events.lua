local wezterm = require 'wezterm'
local tab_title = require 'core.tab_title'

local M = {}

function M.setup()
  -- タブタイトルのセットアップ
  tab_title.setup()
end

return M