local wezterm = require 'wezterm'

local M = {}

-- name -> GitHub URL のレジストリ
M.registry = {
  ['claude-usage.wezterm'] = 'https://github.com/shabaraba/claude-usage.wezterm',
}

-- core/plugins/local/*.lua を走査し、{ name = url } の上書きエントリを集める。
-- init.lua と *.lua.example は対象外（サンプル/プレースホルダのため）。
-- wezterm.glob は非同期実装でconfig読み込み中に使うとyieldエラーになるため、
-- 同期的な wezterm.read_dir を使う。
local function get_local_overrides()
  local overrides = {}
  local local_dir = wezterm.config_dir .. '/core/plugins/local'
  local ok, entries = pcall(wezterm.read_dir, local_dir)
  if not ok then
    return overrides
  end
  for _, path in ipairs(entries) do
    if path:match('%.lua$') and not path:match('init%.lua$') then
      local dofile_ok, override = pcall(dofile, path)
      if dofile_ok and override and override.name and override.url then
        overrides[override.name] = override.url
      end
    end
  end
  return overrides
end

-- name で登録されたプラグインをrequireする。
-- plugins/local/*.lua に同名の上書きがあれば、そちらのURL（file://等）を優先する。
function M.require(name)
  local overrides = get_local_overrides()
  local url = overrides[name] or M.registry[name]
  if not url then
    error('Unknown plugin: ' .. name)
  end
  return wezterm.plugin.require(url)
end

return M
