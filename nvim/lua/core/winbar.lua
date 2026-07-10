local M = {}

local function patch_winbar(win, bufnr)
  if vim.bo[bufnr].buftype ~= "" then return end

  local current = vim.wo[win].winbar
  if not current or current == "" then return end
  if not current:find("%#Saga", 1, true) then return end
  if current:find("🌿", 1, true) then return end

  local branch = require("core.worktree").get_branch(bufnr)
  if not branch then return end

  vim.wo[win].winbar = "🌿 " .. branch .. "  " .. current
end

function M.setup()
  local group = vim.api.nvim_create_augroup("CoreWinbar", { clear = true })

  -- sagaのCursorMovedによるwinbar更新後に割り込む
  vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
    group = group,
    callback = function(ev)
      vim.schedule(function()
        local win = vim.api.nvim_get_current_win()
        if vim.api.nvim_get_current_buf() ~= ev.buf then return end
        patch_winbar(win, ev.buf)
      end)
    end,
  })

  -- sagaのSagaSymbolUpdate（非同期シンボル取得完了）後に割り込む
  vim.api.nvim_create_autocmd("User", {
    pattern = "SagaSymbolUpdate",
    group = group,
    callback = function(ev)
      vim.schedule(function()
        local win = vim.api.nvim_get_current_win()
        if vim.api.nvim_get_current_buf() ~= ev.buf then return end
        patch_winbar(win, ev.buf)
      end)
    end,
  })
end

return M
