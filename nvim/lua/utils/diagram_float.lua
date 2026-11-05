local M = {}

local SCREEN_RATIO = 0.9

local function find_diagram_at_cursor(integration, bufnr)
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  for _, diagram in ipairs(integration.query_buffer_diagrams(bufnr)) do
    local _, newline_count = diagram.source:gsub('\n', '')
    local closing_fence_row = diagram.range.start_row + newline_count + 1
    if row >= diagram.range.start_row and row <= closing_fence_row then
      return diagram
    end
  end
end

local function find_renderer(integration, renderer_id)
  for _, renderer in ipairs(integration.renderers) do
    if renderer.id == renderer_id then
      return renderer
    end
  end
end

local function fit_size(image)
  local term = require('image.utils.term').get_size()
  local max_cols = math.floor(vim.o.columns * SCREEN_RATIO) - 2
  local max_rows = math.floor((vim.o.lines - vim.o.cmdheight) * SCREEN_RATIO) - 2
  local cols = image.image_width / term.cell_width
  local rows = image.image_height / term.cell_height
  local ratio = math.min(1, max_cols / cols, max_rows / rows)
  return math.max(1, math.floor(cols * ratio)), math.max(1, math.floor(rows * ratio))
end

local function open_float(path, renderer_id)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'wipe'
  local image = require('image').from_file(path, { buffer = buf })
  if not image then
    vim.ui.open(path)
    return
  end

  local width, height = fit_size(image)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2) - 1,
    style = 'minimal',
    border = 'rounded',
    title = ' ' .. renderer_id .. '  q: close  o: open in viewer ',
    title_pos = 'center',
  })
  image.window = win
  image.geometry.width = width
  image.geometry.height = height
  image:render()

  local closed = false
  local function close()
    if closed then
      return
    end
    closed = true
    image:clear()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set('n', 'q', close, { buffer = buf, nowait = true, desc = 'Close diagram' })
  vim.keymap.set('n', '<Esc>', close, { buffer = buf, desc = 'Close diagram' })
  vim.keymap.set('n', 'o', function()
    vim.ui.open(path)
  end, { buffer = buf, desc = 'Open diagram in system viewer' })
  vim.api.nvim_create_autocmd('WinLeave', {
    buffer = buf,
    once = true,
    callback = function()
      vim.schedule(close)
    end,
  })
end

function M.show(integration, renderer_options)
  local diagram = find_diagram_at_cursor(integration, vim.api.nvim_get_current_buf())
  if not diagram then
    vim.notify('No diagram found at cursor', vim.log.levels.INFO)
    return
  end

  local renderer = find_renderer(integration, diagram.renderer_id)
  local result = renderer and renderer.render(diagram.source, renderer_options[diagram.renderer_id] or {})
  if not result then
    return
  end

  local function show()
    if vim.fn.filereadable(result.file_path) == 0 then
      vim.notify('Diagram render failed: ' .. result.file_path, vim.log.levels.ERROR)
      return
    end
    open_float(result.file_path, diagram.renderer_id)
  end

  if not result.job_id then
    show()
    return
  end

  vim.notify('Rendering ' .. diagram.renderer_id .. ' diagram...', vim.log.levels.INFO)
  local timer = vim.uv.new_timer()
  timer:start(0, 100, vim.schedule_wrap(function()
    if timer:is_closing() or vim.fn.jobwait({ result.job_id }, 0)[1] == -1 then
      return
    end
    timer:close()
    show()
  end))
end

return M
