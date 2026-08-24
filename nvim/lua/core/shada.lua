-- shada の一時ファイルを回収する。
--
-- nvim は既存の shada を置き換える際、まず <shada>.tmp.<a-z> に書いてから rename する。
-- 複数インスタンスが同時に終了すると置き換えが競合して E137 になり、そのとき nvim は
-- 「E136: Do not forget to remove ... or rename it manually」と言って tmp を残す。
-- nvim 自身は残した tmp を二度と掃除しないため、a-z の 26 個が埋まると E138 となり
-- 以後どのインスタンスも履歴を保存できなくなる。
--
-- 10 並列を超えたあたりから再現するため、常時多数の nvim を開く運用では避けられない。
-- nvim がユーザーに委ねている後始末を起動時に行う。

local M = {}

-- 書き込み中の tmp を消すとそのインスタンスの保存を壊すため、十分に古いものだけ消す。
-- 正常な書き込みはミリ秒で終わる。
local STALE_SECONDS = 300

local function shada_dir()
  local file = vim.o.shadafile
  if file ~= "" and file ~= "NONE" then
    return vim.fn.fnamemodify(file, ":h")
  end
  return vim.fn.stdpath("state") .. "/shada"
end

--- @return number 削除した数
function M.sweep()
  local dir = shada_dir()
  local now = os.time()
  local removed = 0
  for _, path in ipairs(vim.fn.glob(dir .. "/*.tmp.*", true, true)) do
    local stat = vim.uv.fs_stat(path)
    if stat and (now - stat.mtime.sec) > STALE_SECONDS then
      if vim.uv.fs_unlink(path) then
        removed = removed + 1
      end
    end
  end
  return removed
end

function M.setup()
  if vim.o.shadafile == "NONE" then
    return
  end
  -- VimEnter や vim.schedule は headless では走らないことがあるため同期で実行する。
  -- 対象は数十エントリのディレクトリ 1 つで、コストは 1ms 未満
  M.sweep()
end

return M
