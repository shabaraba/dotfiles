#!/usr/bin/env bash
set -e

# Setup GitHub repository protection settings
# This script is part of gh:repo-init task suite

# Get repository information
REMOTE_URL=$(git remote get-url origin 2>/dev/null || { echo "Error: Not in a git repository"; exit 1; })

if [[ $REMOTE_URL =~ github\.com[:/]([^/]+)/(.+)$ ]]; then
    REPO_OWNER="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]}"
    # Remove .git suffix if present
    REPO_NAME="${REPO_NAME%.git}"
else
    echo "Error: Could not parse GitHub repository from git remote"
    exit 1
fi

echo "Setting up protection for: $REPO_OWNER/$REPO_NAME"

# Auto-delete merged branches
gh api "repos/$REPO_OWNER/$REPO_NAME" \
    --method PATCH \
    --field delete_branch_on_merge=true \
    --silent
echo "✓ Auto-delete merged branches enabled"

# GitHub Actions permissions
gh api "repos/$REPO_OWNER/$REPO_NAME/actions/permissions/workflow" \
    --method PUT \
    --field default_workflow_permissions=write \
    --field can_approve_pull_request_reviews=true \
    --silent
echo "✓ GitHub Actions PR permissions enabled"

# Branch protection (optional - controlled by SKIP_BRANCH_PROTECTION env var)
if [ "${SKIP_BRANCH_PROTECTION:-false}" != "true" ]; then
    gh api "repos/$REPO_OWNER/$REPO_NAME/branches/main/protection" \
        --method PUT \
        --input - <<'EOF' --silent
{
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": false,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 0
  },
  "enforce_admins": true,
  "required_status_checks": null,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
    echo "✓ Branch protection enabled (PR-only merges, enforced for admins)"
fi
