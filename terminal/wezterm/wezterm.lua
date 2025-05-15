local wezterm = require 'wezterm'

-- イベントハンドラーの設定
require('core.events').setup()

-- 設定をロード
local config = require('config')

return config