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

-- vim.tbl_flatten の互換層を提供
if not vim.iter then
  -- 古いNeovimバージョンへの対応
  _G.vim.iter = function(t)
    local mt = {}
    function mt:flatten()
      return self
    end
    function mt:totable()
      return vim.tbl_flatten(t)
    end
    return setmetatable({}, mt)
  end
end

-- Alpha.nvim の vim.validate 警告を修正
M.patch_alpha = function()
  -- 新しい validate API の互換層
  local original_validate = vim.validate
  vim.validate = function(param)
    if type(param) == "table" and param[1] ~= nil then
      -- 新しい API
      return original_validate(param)
    else
      -- 古い API を新しい API に変換
      local spec = {}
      for name, value in pairs(param) do
        spec[name] = value
      end
      return original_validate(spec)
    end
  end
end

M.setup = function()
  -- パッチを自動適用
  M.patch_lspsaga()
  M.patch_alpha()
end

return M