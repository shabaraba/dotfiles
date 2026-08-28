-- shada の一時ファイル回収と、破損した shada の復旧を起動時に行う。
-- どちらも nvim がユーザーに委ねている後始末で、放置するとどのインスタンスも履歴を
-- 保存できなくなる。shada の読み込みは startup step 16 と、ユーザー設定の step 8 より
-- 後なので、ここで直しておけばエラーは表に出ない。
--
-- 【tmp の回収】
-- nvim は既存の shada を置き換える際、まず <shada>.tmp.<a-z> に書いてから rename する。
-- 複数インスタンスが同時に終了すると置き換えが競合して E137 になり、そのとき nvim は
-- 「E136: Do not forget to remove ... or rename it manually」と言って tmp を残す。
-- 残した tmp は二度と掃除されないため、a-z の 26 個が埋まると E138 になる。
-- 10 並列を超えたあたりから再現するため、常時多数の nvim を開く運用では避けられない。
--
-- 【破損の復旧】
-- shada が壊れると起動のたびに E576 が出る。壊れた本体を退避し、無傷の候補を昇格させる。

local M = {}

-- 書き込み中の tmp を消すとそのインスタンスの保存を壊すため、十分に古いものだけ消す。
-- 正常な書き込みはミリ秒で終わる。
local STALE_SECONDS = 300

-- 同じ理由で、昇格候補にするのも書き込みが終わったと言える程度に古いものだけ。
local MIN_CANDIDATE_AGE = 10

local function shada_path()
  local file = vim.o.shadafile
  if file ~= "" and file ~= "NONE" then
    return file
  end
  return vim.fn.stdpath("state") .. "/shada/main.shada"
end

--- msgpack の符号なし整数を 1 つ読む。
--- @return number|nil value, number|nil next_pos
local function read_uint(data, pos)
  local head = data:byte(pos)
  if not head then
    return nil
  end
  if head <= 0x7f then
    return head, pos + 1
  end
  local width = ({ [0xcc] = 1, [0xcd] = 2, [0xce] = 4, [0xcf] = 8 })[head]
  if not width then
    return nil
  end
  local value = 0
  for i = pos + 1, pos + width do
    local byte = data:byte(i)
    if not byte then
      return nil
    end
    value = value * 256 + byte
  end
  return value, pos + width + 1
end

--- エントリ境界を辿って構造を検証する。
--- shada は <type> <timestamp> <length> <data> の繰り返しで、先頭 3 つは必ず符号なし
--- 整数。data の中身は読まず length 分読み飛ばすだけなので、エントリ数に比例した実費で
--- 済む。type 0 は kSDItemMissing で、ファイル中に現れると nvim が E576 を出す。
local function is_intact(data)
  local pos = 1
  while pos <= #data do
    local entry_type
    entry_type, pos = read_uint(data, pos)
    if not entry_type or entry_type == 0 then
      return false
    end
    local timestamp
    timestamp, pos = read_uint(data, pos)
    if not timestamp then
      return false
    end
    local length
    length, pos = read_uint(data, pos)
    if not length then
      return false
    end
    pos = pos + length
  end
  -- 末尾を超えて読み飛ばしていれば途中で切れている
  return pos == #data + 1
end

local function is_intact_file(path)
  local fd = io.open(path, "rb")
  if not fd then
    return false
  end
  local data = fd:read("a")
  fd:close()
  return data ~= nil and #data > 0 and is_intact(data)
end

--- 本体が壊れたときに昇格させる候補のうち、無傷で最も新しいものを選ぶ。
--- 取りこぼした tmp は本体より新しい履歴を持つことがあるため、世代バックアップより優先
--- されるよう mtime だけで比較する。
local function newest_intact_candidate(main)
  local dir = vim.fn.fnamemodify(main, ":h")
  local paths = vim.fn.glob(dir .. "/*.tmp.*", true, true)
  table.insert(paths, main .. ".bak")

  local now = os.time()
  local best, best_mtime = nil, -1
  for _, path in ipairs(paths) do
    local stat = vim.uv.fs_stat(path)
    -- 検証はファイル読み込みを伴うので、候補になり得ないものは先に落とす
    if
      stat
      and stat.type == "file"
      and (now - stat.mtime.sec) >= MIN_CANDIDATE_AGE
      and stat.mtime.sec > best_mtime
      and is_intact_file(path)
    then
      best, best_mtime = path, stat.mtime.sec
    end
  end
  return best
end

--- 無傷と確認できた本体を 1 世代だけ控えておく。tmp が残っていない状況での最後の砦。
local function backup(main)
  local bak = main .. ".bak"
  local src = vim.uv.fs_stat(main)
  local dst = vim.uv.fs_stat(bak)
  if not src or (dst and dst.mtime.sec >= src.mtime.sec) then
    return
  end
  -- 直接上書きすると中断時にバックアップまで失うため、別名で作ってから入れ替える
  local staging = bak .. ".new"
  if vim.uv.fs_copyfile(main, staging) then
    os.rename(staging, bak)
  end
end

--- @return string|nil 昇格させた候補のパス
function M.repair()
  local main = shada_path()
  if not vim.uv.fs_stat(main) then
    return nil
  end
  if is_intact_file(main) then
    backup(main)
    return nil
  end

  local candidate = newest_intact_candidate(main)
  -- 退避先は固定名。溜め込まず、直近の 1 件だけ調査用に残す
  if not os.rename(main, main .. ".corrupt") then
    return nil
  end
  if not candidate then
    return nil
  end
  -- rename ではなく複製する。候補が .bak だった場合に最後の砦を消さないため
  if not vim.uv.fs_copyfile(candidate, main) then
    return nil
  end
  return candidate
end

--- @return number 削除した数
function M.sweep()
  local dir = vim.fn.fnamemodify(shada_path(), ":h")
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
  --
  -- sweep より先に repair する。昇格候補は STALE_SECONDS より古いこともある
  local restored = M.repair()
  M.sweep()

  if restored then
    vim.schedule(function()
      vim.notify(
        ("shada が破損していたため %s から復旧しました"):format(vim.fn.fnamemodify(restored, ":t")),
        vim.log.levels.WARN
      )
    end)
  end
end

return M
