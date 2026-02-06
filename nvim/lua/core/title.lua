local M = {}

local EMOJIS = {
  "🚀", "🔥", "⚡", "💎", "🌟", "🎯", "🔮", "🌈", "🍀", "🎨",
  "🦊", "🐳", "🦋", "🐙", "🦄", "🌸", "🌻", "🍁", "🌴", "🌵",
  "🎸", "🎹", "🎺", "🎭", "🎪", "🏔️", "🌋", "🏝️", "⛵", "🚁",
}

local MAX_WIDTH = 40

local cache = {
  cwd = nil,
  title = nil,
}

local function hash_string(str)
  local hash = 0
  for i = 1, #str do
    hash = (hash * 31 + string.byte(str, i)) % 2147483647
  end
  return hash
end

local function get_emoji(repo_name)
  local index = (hash_string(repo_name) % #EMOJIS) + 1
  return EMOJIS[index]
end

local function get_git_info()
  local root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
  if not root or root == "" or root:match("^fatal:") then
    return nil, nil
  end

  local branch = vim.fn.systemlist("git branch --show-current 2>/dev/null")[1]
  if not branch or branch == "" then
    local head = vim.fn.systemlist("git rev-parse --short HEAD 2>/dev/null")[1]
    branch = head and (":" .. head) or nil
  end

  return vim.fn.fnamemodify(root, ":t"), branch
end

function M.get_title()
  local cwd = vim.fn.getcwd()

  if cache.cwd == cwd and cache.title then
    return cache.title
  end

  local repo_name, branch = get_git_info()
  local title

  if repo_name then
    local emoji = get_emoji(repo_name)
    local base = emoji .. " " .. repo_name

    if branch then
      local full = base .. " → " .. branch
      title = (#full <= MAX_WIDTH) and full or base
    else
      title = base
    end
  else
    title = vim.fn.fnamemodify(cwd, ":t")
  end

  cache.cwd = cwd
  cache.title = title

  return title
end

return M
