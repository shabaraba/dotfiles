-- 設定のマージ用ヘルパー関数
local function merge_tables(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
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
  
  return config
end

return get_config()