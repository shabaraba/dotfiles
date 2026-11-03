local M = {}

local RETENTION_SECONDS = 30 * 24 * 60 * 60
local CHECK_INTERVAL_MS = 24 * 60 * 60 * 1000
local timer

function M.sweep()
  local dir = vim.fn.stdpath("state") .. "/undo"
  local entries = vim.uv.fs_scandir(dir)
  if not entries then
    return 0
  end

  local cutoff = os.time() - RETENTION_SECONDS
  local removed = 0
  while true do
    local name = vim.uv.fs_scandir_next(entries)
    if not name then
      break
    end

    local path = dir .. "/" .. name
    local stat = vim.uv.fs_lstat(path)
    if stat and stat.type == "file" and stat.mtime.sec <= cutoff then
      if vim.uv.fs_unlink(path) then
        removed = removed + 1
      end
    end
  end
  return removed
end

function M.setup()
  if timer then
    vim.fn.timer_stop(timer)
  end
  M.sweep()
  timer = vim.fn.timer_start(CHECK_INTERVAL_MS, function()
    M.sweep()
  end, { ["repeat"] = -1 })
end

return M
