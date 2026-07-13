local M = {}

local GIT_ICON = "\xEF\x84\xA6 " -- U+F126 Nerd Font git branch icon (same as p10k)
-- 水平分割の境界線として使う横線（laststatus=0だとNeovimは水平セパレータを描画しないため代用）
-- ハイライトは指定せず、Neovim組み込みのWinBar/WinBarNC（フォーカス状態で自動切替）に委ねる
local SEPARATOR_LINE = "%{repeat('─', winwidth(0))}"

local WINBAR_BG_FALLBACK = "#2f333d" -- Stringハイライトが取得できない場合のフォールバック
local WINBAR_FG = "#1e1e1e" -- 文字列色の背景に対するコントラスト用(視認性重視で黒系固定)
local WINBARNC_BG = "#202226" -- 非アクティブウィンドウのwinbar背景

local function resolve_hex_fg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  if not hl.fg then return nil end
  return string.format("#%06x", hl.fg)
end

-- lspsagaのパンくず(フォルダ/ファイル名/セパレータ)も同じ濃色に揃えて視認性を確保する
-- 実際にwinbar文字列内で使われるのは"Winbar"接頭辞のない実体グループ
-- （SagaWinbarXxxはこれらへのlinkでしかなく、文字列組み立て側は直接SagaXxxを使う）
local SAGA_WINBAR_GROUPS = {
  "SagaSep",
  "SagaFileName",
  "SagaFolderName",
  "SagaFolder",
  "SagaFileIcon",
}

local function ensure_winbar_highlight()
  local active_bg = resolve_hex_fg("String") or WINBAR_BG_FALLBACK
  vim.api.nvim_set_hl(0, "WinBar", { bg = active_bg, fg = WINBAR_FG })
  vim.api.nvim_set_hl(0, "WinBarNC", { bg = WINBARNC_BG })

  for _, group in ipairs(SAGA_WINBAR_GROUPS) do
    vim.api.nvim_set_hl(0, group, { fg = WINBAR_FG })
  end
end

local function patch_winbar(win, bufnr)
  if vim.bo[bufnr].buftype ~= "" then return end

  local current = vim.wo[win].winbar

  if not current or current == "" or not current:find("%#Saga", 1, true) then
    if current ~= SEPARATOR_LINE then
      vim.wo[win].winbar = SEPARATOR_LINE
    end
    return
  end

  -- 先頭にすでにgitアイコンがある場合はスキップ
  if current:sub(1, #GIT_ICON) == GIT_ICON then return end

  local branch = require("core.worktree").get_branch(bufnr)
  if not branch then return end

  vim.wo[win].winbar = GIT_ICON .. branch .. "  " .. current
end

function M.setup()
  local group = vim.api.nvim_create_augroup("CoreWinbar", { clear = true })

  ensure_winbar_highlight()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = ensure_winbar_highlight,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter", "WinEnter" }, {
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
