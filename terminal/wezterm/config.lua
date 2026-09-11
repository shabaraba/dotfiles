local wezterm = require 'wezterm'
local plugins = require 'core.plugins'

-- 設定のマージ用ヘルパー関数
local function merge_tables(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

local function require_ai_usage()
  local dev_dir = os.getenv('HOME') .. '/workspace/private/ai-usage.wezterm'
  local ok, ai_usage = pcall(dofile, dev_dir .. '/plugin/init.lua')
  if ok and ai_usage then
    wezterm.log_info('config.lua: using ai-usage dev workspace plugin')
    return ai_usage
  end

  wezterm.log_info('config.lua: falling back to registered ai-usage plugin')
  return plugins.require('ai-usage.wezterm')
end

-- 設定を集約
local function get_config()
  local config = {}

  -- 各設定モジュールから設定を取得
  local modules = {
    'utils.platform',
    'settings.window',
    'settings.font',
    'settings.colors',
    'key_bindings.init',
  }

  for _, module_name in ipairs(modules) do
    local module = require(module_name)
    local module_config = nil

    if module_name == 'utils.platform' then
      module_config = { default_prog = module.get_default_prog() }
    else
      module_config = module.get_config()
    end

    merge_tables(config, module_config)
  end

  -- Claude Code/Codexの使用量をタブバーに表示する。開発用ワークスペースがあれば直接読み、
  -- なければ core/plugins/init.lua の registry/override 経由で読み込む。
  local ai_usage = require_ai_usage()
  ai_usage.apply_to_config(config, {
    position = 'left',
    refresh_interval = 60,
    toggle_key = { key = 'u', mods = 'CTRL|SHIFT' },
  })

  return config
end

return get_config()
