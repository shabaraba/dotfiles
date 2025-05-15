local M = {}

function M.detect_platform()
  local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
  local os_name = nil
  
  if BinaryFormat == "dll" then
    os_name = "Windows"
  elseif BinaryFormat == "so" then
    os_name = "Linux"
  elseif BinaryFormat == "dylib" then
    os_name = "MacOS"
  end
  
  return os_name
end

function M.get_default_prog()
  local os_name = M.detect_platform()
  
  if os_name == 'Windows' then
    return { "wsl.exe", "--exec", "/bin/zsh", "-l" }
  end
  
  return nil
end

return M