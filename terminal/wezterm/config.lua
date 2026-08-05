local wezterm = require 'wezterm'
local plugins = require 'core.plugins'

-- 設定のマージ用ヘルパー関数
local function merge_tables(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

local function require_claude_usage()
  local local_path = wezterm.config_dir .. '/core/plugins/local/claude-usage.wezterm/plugin/init.lua'
  local ok, claude_usage = pcall(dofile, local_path)
  if ok and claude_usage then
    wezterm.log_info('config.lua: using local claude-usage fixed plugin')
    return claude_usage
  end

  wezterm.log_info('config.lua: falling back to registered claude-usage plugin')
  return plugins.require('claude-usage.wezterm')
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

  -- Claude Codeの使用量をタブバーに表示する。local固定版があれば直接読み、
  -- なければ core/plugins/init.lua の registry/override 経由で読み込む。
  local claude_usage = require_claude_usage()
  claude_usage.apply_to_config(config, {
    position = 'left',
    refresh_interval_secs = 60,
  })

  return config
end

return get_config()
