local M = {}

local GIT_ICON = " "

local function patch_winbar(win, bufnr)
  if vim.bo[bufnr].buftype ~= "" then return end

  local current = vim.wo[win].winbar
  if not current or current == "" then return end
  if not current:find("%#Saga", 1, true) then return end
  -- 先頭にすでにgitアイコンがある場合はスキップ
  if current:sub(1, #GIT_ICON) == GIT_ICON then return end

  local branch = require("core.worktree").get_branch(bufnr)
  if not branch then return end

  vim.wo[win].winbar = GIT_ICON .. branch .. "  " .. current
end

function M.setup()
  local group = vim.api.nvim_create_augroup("CoreWinbar", { clear = true })

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
