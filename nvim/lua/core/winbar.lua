local M = {}

local GIT_ICON = "\xEF\x84\xA6 " -- U+F126 Nerd Font git branch icon (same as p10k)
-- 水平分割の境界線として使う横線（laststatus=0だとNeovimは水平セパレータを描画しないため代用）
-- ハイライトは指定せず、Neovim組み込みのWinBar/WinBarNC（フォーカス状態で自動切替）に委ねる
local SEPARATOR_LINE = "%{repeat('─', winwidth(0))}"

local WINBAR_BG_FALLBACK = "#2f333d" -- Stringハイライトが取得できない場合のフォールバック
local WINBARNC_BG = "#202226" -- 非アクティブウィンドウのwinbar背景

local function resolve_hex_fg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  if not hl.fg then return nil end
  return string.format("#%06x", hl.fg)
end

local CONTRAST_DARK = "#1e1e1e"
local CONTRAST_LIGHT = "#f0f0f0"

-- 背景色の知覚輝度(YIQ)から読みやすい文字色(黒 or 白系)を選ぶ
-- 単純なRGB反転は中間輝度の彩度色だと別の中間輝度色になりコントラストが弱いため使わない
local function contrast_fg(hex)
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)
  local brightness = (r * 299 + g * 587 + b * 114) / 1000
  return brightness >= 128 and CONTRAST_DARK or CONTRAST_LIGHT
end

-- lspsagaのパンくず(フォルダ/ファイル名/セパレータ)はアクティブウィンドウでのみ濃色にする
-- 実際にwinbar文字列内で使われるのは"Winbar"接頭辞のない実体グループ
-- （SagaWinbarXxxはこれらへのlinkでしかなく、文字列組み立て側は直接SagaXxxを使う）
local BASE_SAGA_WINBAR_GROUPS = {
  "SagaSep",
  "SagaFileName",
  "SagaFolderName",
  "SagaFolder",
  "SagaFileIcon",
}

local BREADCRUMB_ACTIVE_GROUP = "CoreWinBarBreadcrumb"
local BREADCRUMB_INACTIVE_GROUP = "CoreWinBarBreadcrumbNC"

-- lspsagaのファイル名パンくずは日本語等の全角文字でも幅チェックをしないため、
-- ウィンドウ幅を超える文字列がそのまま描画され隣のウィンドウにはみ出すことがある。
-- ここで表示幅を計算して安全にクリップする（マージンはアイコングリフの表示幅ズレの吸収用）
local WIDTH_SAFETY_MARGIN = 4
local ELLIPSIS = "…"

local function strip_stl_markup(str)
  return (str:gsub("%%#%w+#", ""):gsub("%%%*", ""))
end

-- statuslineのハイライト指定(%#Group#, %*)を維持したまま表示幅でクリップする
local function clip_to_width(str, max_width)
  if max_width <= 0 then return "" end
  -- %{...} / %{%...%} は評価前の文字列から表示幅を測れず、途中で切ると
  -- E540 (Unclosed expression sequence) になるためクリップ対象外にする。
  -- 例: SEPARATOR_LINE の "%{repeat('─', winwidth(0))}"
  if str:find("%%{") then return str end
  if vim.fn.strdisplaywidth(strip_stl_markup(str)) <= max_width then return str end

  local budget = math.max(max_width - vim.fn.strwidth(ELLIPSIS), 0)
  local out, width, pos, len = {}, 0, 1, #str

  while pos <= len do
    local s, e = str:find("^%%#%w+#", pos)
    if not s then s, e = str:find("^%%%*", pos) end
    if s then
      out[#out + 1] = str:sub(s, e)
      pos = e + 1
    else
      local next_markup = str:find("%%[#%*]", pos)
      local text_end = (next_markup and next_markup - 1) or len
      for _, ch in ipairs(vim.fn.split(str:sub(pos, text_end), "\\zs")) do
        local w = vim.fn.strwidth(ch)
        if width + w > budget then
          out[#out + 1] = ELLIPSIS
          return table.concat(out)
        end
        out[#out + 1] = ch
        width = width + w
      end
      pos = text_end + 1
    end
  end

  return table.concat(out)
end

local function is_floating(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

-- シンボルパンくず(関数名/メソッド名等)はLSPシンボル種別ごとに"Saga<Kind>"という
-- 別グループを使うため、lspsaga側の種別一覧から動的にグループ名を収集する
local winhighlight_cache = {}

local function build_winhighlight(target_group)
  if winhighlight_cache[target_group] then return winhighlight_cache[target_group] end

  local groups = vim.deepcopy(BASE_SAGA_WINBAR_GROUPS)
  local ok, lspkind = pcall(require, "lspsaga.lspkind")
  local has_kinds = ok and lspkind.kind ~= nil
  if has_kinds then
    for _, item in pairs(lspkind.kind) do
      table.insert(groups, "Saga" .. item[1])
      table.insert(groups, "Saga" .. item[1] .. "Word")
    end
  end

  local parts = {}
  for _, group in ipairs(groups) do
    table.insert(parts, group .. ":" .. target_group)
  end
  local result = table.concat(parts, ",")
  -- lspsaga未ロードで種別グループを取りこぼした場合はキャッシュせず、
  -- 次回呼び出しで完全な割り当てを再構築させる（シンボル部分の色ズレ防止）
  if has_kinds then
    winhighlight_cache[target_group] = result
  end
  return result
end

-- 一度解決できたStringの色を保持する。ColorSchemeがString未定義の瞬間に発火すると
-- resolve_hex_fgがnilを返し、フォールバックの暗色背景→白文字に切り替わって固定されるため、
-- 直近の有効な色を再利用してアクティブ窓の文字色がちらつかないようにする
local last_active_bg

local function ensure_winbar_highlight()
  local resolved = resolve_hex_fg("String")
  if resolved then last_active_bg = resolved end
  local active_bg = last_active_bg or WINBAR_BG_FALLBACK
  local active_fg = contrast_fg(active_bg)
  -- 非アクティブwinbarは暗い背景なので、その背景に対して読める文字色を選ぶ
  -- （Sagaネイティブfgはアクティブ側の明背景向けで、暗背景だと潰れて見えなくなる）
  local inactive_fg = contrast_fg(WINBARNC_BG)
  vim.api.nvim_set_hl(0, "WinBar", { bg = active_bg, fg = active_fg })
  vim.api.nvim_set_hl(0, "WinBarNC", { bg = WINBARNC_BG, fg = inactive_fg })
  vim.api.nvim_set_hl(0, BREADCRUMB_ACTIVE_GROUP, { fg = active_fg })
  vim.api.nvim_set_hl(0, BREADCRUMB_INACTIVE_GROUP, { fg = inactive_fg })
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

  local combined = GIT_ICON .. branch .. "  " .. current
  vim.wo[win].winbar = clip_to_width(combined, vim.api.nvim_win_get_width(win) - WIDTH_SAFETY_MARGIN)
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

  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = group,
    callback = function()
      if is_floating(0) then return end
      vim.wo.winhighlight = build_winhighlight(BREADCRUMB_ACTIVE_GROUP)
    end,
  })

  -- 非アクティブ窓もクリアせず専用グループへ割り当てる。クリアするとSagaネイティブ色
  -- （アクティブ側の明背景向けの濃色）が暗いWinBarNC背景に乗って読めなくなるため
  vim.api.nvim_create_autocmd("WinLeave", {
    group = group,
    callback = function()
      if is_floating(0) then return end
      vim.wo.winhighlight = build_winhighlight(BREADCRUMB_INACTIVE_GROUP)
    end,
  })

  -- ウィンドウ分割/リサイズ直後はwinbarが古い幅のまま再描画されず
  -- 隣のペインに文字がはみ出て残ることがあるため、強制的に全画面再描画する
  vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = group,
    callback = function()
      vim.schedule(function()
        vim.cmd.redraw({ bang = true })
      end)
    end,
  })

  -- lspsagaはCursorMoved等で同期的にwinbarを再設定するため、こちらの
  -- patch_winbar（vim.schedule経由）が追いつく前に幅チェックなしの文字列が
  -- 一瞬描画されることがある。OptionSetで即座に横幅クリップして安全弁とする
  local suppress_option_set = false
  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "winbar",
    callback = function()
      if suppress_option_set then return end
      local win = vim.api.nvim_get_current_win()
      if is_floating(win) then return end

      local current = vim.wo[win].winbar
      local clipped = clip_to_width(current, vim.api.nvim_win_get_width(win) - WIDTH_SAFETY_MARGIN)
      if clipped == current then return end

      suppress_option_set = true
      vim.wo[win].winbar = clipped
      suppress_option_set = false
    end,
  })
end

return M
