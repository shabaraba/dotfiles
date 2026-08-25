local M = {}

-- vibing.nvim は完了イベントを発行しないため、サマリーの挿入先
-- （"# Vibing Chat" 見出しと直後の "---" 区切りの間。vibing.nvim の
-- summary_inserter と同じ範囲）の変化を :VibingSummarize の完了シグナルとして使う
local POLL_INTERVAL_MS = 500
local TIMEOUT_MS = 90000

---@param buf number
---@return string
local function summary_region(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local start_line = nil

  for i, line in ipairs(lines) do
    if start_line then
      if line:match("^%-%-%-$") then
        return table.concat(lines, "\n", start_line, i)
      end
    elseif line:match("^# Vibing Chat") then
      start_line = i
    end
  end

  if start_line then
    return table.concat(lines, "\n", start_line)
  end

  return ""
end

---@param buf number
local function set_file_title(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  -- 待機中にカーソルが別ウィンドウへ移っていても、対象は元のチャットバッファ
  vim.api.nvim_buf_call(buf, function()
    vim.cmd "VibingSetFileTitle"
  end)
end

---@param buf number
---@param before string
---@param elapsed number
local function wait_for_summary(buf, before, elapsed)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  if summary_region(buf) ~= before then
    set_file_title(buf)
    return
  end

  if elapsed >= TIMEOUT_MS then
    vim.notify(
      "VibingSummarize did not update the summary; generating title from the excerpt",
      vim.log.levels.WARN
    )
    set_file_title(buf)
    return
  end

  vim.defer_fn(function()
    wait_for_summary(buf, before, elapsed + POLL_INTERVAL_MS)
  end, POLL_INTERVAL_MS)
end

---サマリーを生成し、完了を待ってからファイルタイトルを設定する
---タイトル生成はバッファ内の "## summary" を入力に使うため順序に依存する
function M.summarize_then_set_title()
  local buf = vim.api.nvim_get_current_buf()
  local before = summary_region(buf)

  vim.cmd "VibingSummarize"
  wait_for_summary(buf, before, 0)
end

return M
