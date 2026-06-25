git config --global color.ui auto

function git-shallow-merge() {
  local target=${1:-develop}
  local current=$(git branch --show-current)
  local repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
  local base=$(gh api "repos/$repo/compare/$target...$current" --jq '.merge_base_commit.sha')
  local date=$(git show "$base" --format="%ci" -s)
  git fetch origin "$target" --shallow-since="$date"
  git fetch origin "$current" --shallow-since="$date"
  git merge "origin/$target"
}

# gh uses stored credentials instead of GITHUB_TOKEN env var
gh() {
  GITHUB_TOKEN="" command gh "$@"
}
