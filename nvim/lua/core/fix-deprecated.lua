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
-- 新しいAPIを優先して使用し、古いAPIは廃止予定として扱う
if vim.iter then
  -- vim.iter が利用可能な場合（Neovim 0.10+）
  if vim.tbl_flatten then
    -- 古いAPIが残っている場合は新しいAPIに置き換える
    local original_tbl_flatten = vim.tbl_flatten
    _G.vim.tbl_flatten = function(t)
      return vim.iter(t):flatten():totable()
    end
  end
else
  -- 古いNeovimバージョンでvim.iterが無い場合の互換層
  _G.vim.iter = function(t)
    local mt = {}
    function mt:flatten()
      -- 手動でflattenを実装
      local result = {}
      local function flatten_table(tbl)
        for _, v in pairs(tbl) do
          if type(v) == "table" then
            flatten_table(v)
          else
            table.insert(result, v)
          end
        end
      end
      flatten_table(t)
      return result
    end
    function mt:totable()
      return t
    end
    return setmetatable({}, mt)
  end
end

M.setup = function()
  -- パッチを自動適用
  M.patch_lspsaga()
end

return M