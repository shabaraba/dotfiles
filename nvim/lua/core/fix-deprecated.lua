-- 廃止予定の API を使用しているプラグインの修正
local M = {}

-- lspsaga.nvim の修正パッチ
M.patch_lspsaga = function()
  -- LspAttach イベントで lspsaga のメソッドをオーバーライド
  vim.api.nvim_create_autocmd("User", {
    pattern = "LspsagaLoaded",
    callback = function()
      -- client.request を client:request に置き換える警告を回避
      if pcall(require, "lspsaga") then
        -- パッチ適用は lspsaga の内部実装に依存するため困難
        -- プラグインの更新を待つのが最善
      end
    end,
  })
end

-- vim.tbl_flatten の互換層を提供 (Neovim 0.10+では vim.iter を使用)
if vim.tbl_flatten and not vim.iter then
  -- 古いNeovimバージョンへの対応
  _G.vim.iter = function(t)
    local mt = {}
    function mt:flatten()
      return vim.tbl_flatten(t)
    end
    function mt:totable()
      return vim.tbl_flatten(t)
    end
    return setmetatable({}, mt)
  end
elseif not vim.tbl_flatten and vim.iter then
  -- 新しいNeovimバージョンでvim.tbl_flattenが削除されている場合
  _G.vim.tbl_flatten = function(t)
    return vim.iter(t):flatten():totable()
  end
end

M.setup = function()
  -- パッチを自動適用
  M.patch_lspsaga()
end

return M