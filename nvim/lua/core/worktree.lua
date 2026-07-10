local M = {}

local cache = {}

local function get_buf_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  if name == "" then return nil end
  return vim.fn.fnamemodify(name, ":h")
end

function M.get_branch(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local dir = get_buf_dir(bufnr)
  if not dir then return nil end

  if cache[dir] ~= nil then
    return cache[dir]
  end

  local result = vim.fn.systemlist(
    "git -C " .. vim.fn.shellescape(dir) .. " symbolic-ref --short HEAD 2>/dev/null"
  )[1]

  if result and result ~= "" and not result:match("^fatal:") then
    cache[dir] = result
    return result
  end

  cache[dir] = false
  return nil
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
  callback = function(ev)
    local dir = get_buf_dir(ev.buf)
    if dir then
      cache[dir] = nil
    end
  end,
})

return M
