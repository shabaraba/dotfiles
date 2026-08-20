git config --global color.ui auto

# --- partial clone ---------------------------------------------------------
# 巨大リポジトリは shallow (--depth) ではなく blob フィルタで軽くする。
# shallow は履歴を切り詰めるため graft 境界が生まれ、PR のマージや rebase で
# 履歴が書き換わるとローカルのコミットが到達不能になる。partial clone は
# コミットとツリーを全部持ち blob だけ遅延取得するので、merge / rebase /
# merge-base がすべて素直に動く。サイズは shallow より小さくなることも多い。

# 既存のクローン（shallow でも通常でも）をその場で partial clone に変換する。
#   git-partial-convert [filter]   filter 既定: blob:none
function git-partial-convert() {
  local filter=${1:-blob:none}
  local common
  common=$(git rev-parse --git-common-dir 2>/dev/null) || {
    echo "git リポジトリではありません" >&2; return 1
  }

  git config remote.origin.promisor true
  git config remote.origin.partialclonefilter "$filter"

  if [[ -f "$common/shallow" ]]; then
    echo "==> shallow を解除しつつ $filter で取得"
    git fetch --unshallow --filter="$filter" origin || return 1
  else
    echo "==> $filter で取得"
    git fetch --filter="$filter" origin || return 1
  fi

  git gc
  git-partial-status
}

# partial clone の状態と .git の内訳を点検する。
function git-partial-status() {
  local common filter promisor
  common=$(git rev-parse --git-common-dir 2>/dev/null) || {
    echo "git リポジトリではありません" >&2; return 1
  }

  if [[ -f "$common/shallow" ]]; then
    echo "shallow  : YES ($(wc -l < "$common/shallow" | tr -d ' ') 境界) — --depth 付き fetch の形跡"
  else
    echo "shallow  : no"
  fi

  filter=$(git config remote.origin.partialclonefilter 2>/dev/null)
  promisor=$(git config remote.origin.promisor 2>/dev/null)
  echo "filter   : ${filter:-(なし)}"
  echo "promisor : ${promisor:-(なし)}"
  echo "commits  : $(git rev-list --count HEAD 2>/dev/null)"
  echo ".git     : $(du -sh "$common" 2>/dev/null | cut -f1)"
  git count-objects -vH | grep -E 'size-pack|garbage'
}

# 中断した fetch の残骸（objects/pack/tmp_pack_*）を回収する。
# .git が実パックサイズより極端に大きいときに効く。
function git-gc-garbage() {
  local common
  common=$(git rev-parse --git-common-dir 2>/dev/null) || {
    echo "git リポジトリではありません" >&2; return 1
  }

  if pgrep -f "git (fetch|push|clone|gc|repack)" >/dev/null 2>&1; then
    echo "中断: 他の git プロセスが動いています。終わってから実行してください" >&2
    return 1
  fi

  echo "==> 削除前"
  git count-objects -vH | grep -E 'size-pack|garbage'
  rm -fv "$common"/objects/pack/tmp_pack_*
  git gc --prune=now
  echo "==> 削除後"
  git count-objects -vH | grep -E 'size-pack|garbage'
}

# gh uses stored credentials instead of GITHUB_TOKEN env var
gh() {
  GITHUB_TOKEN="" command gh "$@"
}
