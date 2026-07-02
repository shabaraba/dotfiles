git config --global color.ui auto

function _git_clean_shallow() {
  [[ -f .git/shallow ]] || return
  local tmp sha
  tmp=$(mktemp)
  while IFS= read -r sha; do
    git cat-file -e "$sha" 2>/dev/null && printf '%s\n' "$sha"
  done < .git/shallow > "$tmp"
  mv "$tmp" .git/shallow
}

function git-shallow-merge() {
  local target=${1:-develop}
  local current=$(git branch --show-current)
  local repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
  local base=$(gh api "repos/$repo/compare/$target...$current" --jq '.merge_base_commit.sha')
  local date=$(git show "$base" --format="%ci" -s)
  local adjusted=$(date -j -v-1S -f "%Y-%m-%d %H:%M:%S %z" "$date" "+%Y-%m-%d %H:%M:%S %z")

  git fetch origin "$target" --shallow-since="$adjusted"
  git fetch origin "$current" --shallow-since="$adjusted"

  # 通常パス: シャロー履歴からマージベースが見つかれば普通にマージ
  if git merge-base HEAD "origin/$target" &>/dev/null; then
    git merge "origin/$target"
    return
  fi

  # 深掘りパス: depth を計算して fetch
  local depth=$(gh api "repos/$repo/compare/$base...$target" --jq '.ahead_by')
  if git fetch origin "$target" --depth=$((depth + 2)) 2>/dev/null &&
     git merge-base HEAD "origin/$target" &>/dev/null; then
    git merge "origin/$target"
    return
  fi

  # フォールバック: シャロー履歴が壊れていても merge-tree で直接3-wayマージ
  echo "shallow history broken, falling back to merge-tree (base: $base)"
  local output mt_exit tree_sha
  output=$(git merge-tree --write-tree --merge-base="$base" HEAD "origin/$target" 2>&1)
  mt_exit=$?
  tree_sha=$(echo "$output" | head -1)

  if [[ $mt_exit -eq 0 ]]; then
    git reset --hard "$(git commit-tree "$tree_sha" \
      -p HEAD -p "origin/$target" \
      -m "Merge branch '$target' into $current")"
    _git_clean_shallow
  else
    echo "$output" | tail -n +2
    git read-tree --reset -u HEAD
    git read-tree -m -u "${base}^{tree}" HEAD "origin/$target"
    git rev-parse "origin/$target" > .git/MERGE_HEAD
    printf "Merge branch '%s' into %s\n" "$target" "$current" > .git/MERGE_MSG
    echo "conflicts detected. resolve and run: git merge --continue"
    return 1
  fi
}

# gh uses stored credentials instead of GITHUB_TOKEN env var
gh() {
  GITHUB_TOKEN="" command gh "$@"
}
