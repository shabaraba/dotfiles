#!/usr/bin/env bash
set -euo pipefail

# Publish a local Gitea PR to GitHub as a draft PR
# Usage: mise run pr:publish <pr_number>

PR_NUMBER="${1:-}"
if [ -z "$PR_NUMBER" ]; then
    echo "Usage: mise run pr:publish <pr_number>"
    echo ""
    echo "  Publishes a Gitea PR to GitHub as a draft PR."
    echo "  Run from the repository directory."
    exit 1
fi

GITEA_URL="${GITEA_URL:-http://localhost:3000}"
GITEA_TOKEN="${GITEA_TOKEN:-}"
if [ -z "$GITEA_TOKEN" ]; then
    echo "Error: GITEA_TOKEN is not set. Add it to sh/zsh/private/env.zsh"
    exit 1
fi

# Detect Gitea repo from git remote
GITEA_REMOTE=$(git remote get-url gitea 2>/dev/null || echo "")
if [ -z "$GITEA_REMOTE" ]; then
    echo "Error: No 'gitea' remote found in this repository."
    echo "  Add it with: git remote add gitea git@gitea.local:<owner>/<repo>.git"
    exit 1
fi
# Extract owner/repo from SSH URL (git@gitea.local:shaba/dotfiles.git)
GITEA_REPO=$(echo "$GITEA_REMOTE" | sed 's/.*:\(.*\)\.git/\1/')

echo "Fetching Gitea PR #$PR_NUMBER from $GITEA_REPO ..."

PR_INFO=$(curl -sf \
    -H "Authorization: token $GITEA_TOKEN" \
    "$GITEA_URL/api/v1/repos/$GITEA_REPO/pulls/$PR_NUMBER")

TITLE=$(echo "$PR_INFO" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d['title'])")
BODY=$(echo "$PR_INFO" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d['body'])")
HEAD_BRANCH=$(echo "$PR_INFO" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d['head']['label'])")
BASE_BRANCH=$(echo "$PR_INFO" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d['base']['label'])")

echo "  Title:  $TITLE"
echo "  Branch: $HEAD_BRANCH -> $BASE_BRANCH"
echo ""

echo "Pushing branch to GitHub ..."
git push origin "$HEAD_BRANCH"

echo "Creating draft PR on GitHub ..."
GH_PR_URL=$(gh pr create \
    --draft \
    --title "$TITLE" \
    --body "$BODY" \
    --head "$HEAD_BRANCH" \
    --base "$BASE_BRANCH")

echo ""
echo "Draft PR created: $GH_PR_URL"
