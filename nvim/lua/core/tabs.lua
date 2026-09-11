-- 分割レイアウトを壊さずに現在のバッファだけを一時的に全画面表示するための短縮コマンド。
-- `tab split` は元タブのウィンドウ構成に触れないので、`tabclose` で表示バッファごと復帰する。
--
-- ユーザーコマンドは大文字始まりしか作れないため、小文字はコマンドライン略語で実現する。
-- 略語はキーワード文字以外を打った時点で展開されるので `:tabnew` や `:throw` のように
-- 打鍵が続くものは巻き込まない。加えて行全体が一致するときだけ展開し、範囲や修飾子が
-- 付いた組み込みコマンドを保護する。

local M = {}

local shortcuts = {
  tt = "tab split",
  tq = "tabclose",
  tl = "tabnext",
  th = "tabprevious",
}

function M.setup()
  for lhs, rhs in pairs(shortcuts) do
    vim.keymap.set("ca", lhs, function()
      if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == lhs then
        return rhs
      end
      return lhs
    end, { expr = true })
  end
end

return M
