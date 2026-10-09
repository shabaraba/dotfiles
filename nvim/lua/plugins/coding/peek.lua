local function oil_cursor_path()
  local ok, oil = pcall(require, 'oil')
  if not ok then
    return nil
  end
  local entry, dir = oil.get_cursor_entry(), oil.get_current_dir()
  return entry and dir and dir .. entry.name
end

local function text_cursor_path()
  local cfile = vim.fn.expand('<cfile>')
  if cfile == '' then
    return nil
  end
  cfile = vim.fs.normalize(cfile)
  if cfile:sub(1, 1) == '/' then
    return cfile
  end
  for _, base in ipairs({ vim.fn.expand('%:p:h'), vim.fn.getcwd() }) do
    local path = vim.fs.joinpath(base, cfile)
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

local function cursor_markdown_path()
  local path = vim.bo.filetype == 'oil' and oil_cursor_path() or text_cursor_path()
  if path and vim.fn.filereadable(path) == 1 and vim.filetype.match({ filename = path }) == 'markdown' then
    return path
  end
end

local function open_preview()
  local peek = require('peek')
  local path = cursor_markdown_path()
  if not path then
    return peek.open()
  end
  local bufnr = vim.fn.bufadd(path)
  vim.fn.bufload(bufnr)
  if vim.bo[bufnr].filetype == '' then
    vim.bo[bufnr].filetype = 'markdown'
  end
  vim.api.nvim_buf_call(bufnr, peek.open)
end

local function build(plugin)
  local result = vim.system({ 'deno', 'task', '--quiet', 'build:fast' }, { cwd = plugin.dir }):wait()
  if result.code ~= 0 then
    error('peek.nvim build failed: ' .. result.stderr)
  end

  local bundle = plugin.dir .. '/public/main.bundle.js'
  local file = assert(io.open(bundle, 'r'))
  local source = file:read('*a')
  file:close()

  local patched, count = source:gsub('typographer: true,', 'typographer: true,\n    breaks: true,', 1)
  if count == 0 then
    error('peek.nvim: markdown-it options not found in ' .. bundle)
  end
  file = assert(io.open(bundle, 'w'))
  file:write(patched)
  file:close()
end

return {
  'toppair/peek.nvim',
  build = build,
  cmd = { 'PeekOpen', 'PeekClose' },
  init = function()
    local shims = vim.fn.expand('~/.local/share/mise/shims')
    if vim.fn.executable('deno') == 0 and vim.fn.isdirectory(shims) == 1 then
      vim.env.PATH = shims .. ':' .. vim.env.PATH
    end
  end,
  config = function()
    require('peek').setup({
      app = 'browser',
      auto_load = false,
      theme = 'light',
      syntax = true,
    })
    vim.api.nvim_create_user_command('PeekOpen', open_preview, {})
    vim.api.nvim_create_user_command('PeekClose', function()
      require('peek').close()
    end, {})
  end,
}
