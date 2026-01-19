#!/usr/bin/env bash
set -e

# GitHub repository initialization script
# This script sets up release-please and branch protection for a GitHub repository

# Color output functions
green() { echo -e "\033[32m$1\033[0m"; }
blue() { echo -e "\033[34m$1\033[0m"; }
yellow() { echo -e "\033[33m$1\033[0m"; }
red() { echo -e "\033[31m$1\033[0m"; }

# Show help message
show_help() {
    cat <<'HELP'
Usage: mise run gh:repo-init [OPTIONS]

Initialize GitHub repository with release-please and branch protection.

Options:
  -v, --version <version>        Initial version (default: 0.1.0)
  -t, --release-type <type>      Release type (default: simple)
  --skip-branch-protection       Skip branch protection setup
  -h, --help                     Show this help message

Valid release types:
  simple     - Generic projects (language-agnostic)
  node       - Node.js/JavaScript/TypeScript
  python     - Python
  go         - Go
  rust       - Rust
  ruby       - Ruby
  java       - Java
  php        - PHP
  terraform  - Terraform
  helm       - Helm charts

Examples:
  mise run gh:repo-init
  mise run gh:repo-init --version 1.0.0 --release-type node
  mise run gh:repo-init -v 2.0.0 -t python --skip-branch-protection
HELP
    exit 0
}

# Validate release type
validate_release_type() {
    local type="$1"
    local valid_types=("simple" "node" "python" "go" "rust" "ruby" "java" "php" "terraform" "helm")

    for valid in "${valid_types[@]}"; do
        if [ "$type" = "$valid" ]; then
            return 0
        fi
    done

    red "Error: Invalid release type: $type"
    echo ""
    echo "Valid release types:"
    for valid in "${valid_types[@]}"; do
        echo "  - $valid"
    done
    echo ""
    echo "Use --help for more information"
    exit 1
}

# Default options
VERSION="${VERSION:-0.1.0}"
RELEASE_TYPE="${RELEASE_TYPE:-simple}"
SKIP_BRANCH_PROTECTION="${SKIP_BRANCH_PROTECTION:-false}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            if [[ -z "$2" || "$2" == -* ]]; then
                red "Error: --version requires a value"
                echo "Use --help for usage information"
                exit 1
            fi
            VERSION="$2"
            shift 2
            ;;
        -t|--release-type)
            if [[ -z "$2" || "$2" == -* ]]; then
                red "Error: --release-type requires a value"
                echo "Use --help for usage information"
                exit 1
            fi
            RELEASE_TYPE="$2"
            shift 2
            ;;
        --skip-branch-protection)
            SKIP_BRANCH_PROTECTION="true"
            shift
            ;;
        *)
            red "Error: Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Validate release type
validate_release_type "$RELEASE_TYPE"

# Get repository information from git remote
get_repo_info() {
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || { red "Error: Not in a git repository or no origin remote found"; exit 1; })

    if [[ $REMOTE_URL =~ github\.com[:/]([^/]+)/(.+)$ ]]; then
        REPO_OWNER="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
        # Remove .git suffix if present
        REPO_NAME="${REPO_NAME%.git}"
    else
        red "Error: Could not parse GitHub repository from git remote"
        exit 1
    fi
}

# Create release-please workflow file
create_workflow() {
    mkdir -p .github/workflows
    cat > .github/workflows/release-please.yml <<'EOF'
name: Release Please

on:
  push:
    branches:
      - main

permissions:
  contents: write
  pull-requests: write

jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: googleapis/release-please-action@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          config-file: release-please-config.json
          manifest-file: .release-please-manifest.json
EOF
    green "✓ Created .github/workflows/release-please.yml"
}

# Create release-please config file
create_config() {
    cat > release-please-config.json <<EOF
{
  "\$schema": "https://raw.githubusercontent.com/googleapis/release-please/main/schemas/config.json",
  "packages": {
    ".": {
      "release-type": "$RELEASE_TYPE",
      "bump-minor-pre-major": true,
      "bump-patch-for-minor-pre-major": true,
      "include-component-in-tag": false,
      "changelog-sections": [
        { "type": "feat", "section": "Features" },
        { "type": "fix", "section": "Bug Fixes" },
        { "type": "perf", "section": "Performance Improvements" },
        { "type": "refactor", "section": "Code Refactoring" },
        { "type": "docs", "section": "Documentation" },
        { "type": "chore", "section": "Miscellaneous" }
      ]
    }
  }
}
EOF
    green "✓ Created release-please-config.json (release-type: $RELEASE_TYPE)"
}

# Create release-please manifest file
create_manifest() {
    cat > .release-please-manifest.json <<EOF
{
  ".": "$VERSION"
}
EOF
    green "✓ Created .release-please-manifest.json (v$VERSION)"
}

# Setup pre-commit hook
setup_hook() {
    if [ ! -d .git/hooks ]; then
        red "Error: .git directory not found. Make sure you are in a git repository."
        exit 1
    fi

    cat > .git/hooks/pre-commit <<'EOF'
#!/bin/sh
# Prevent commits directly to main branch

BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH" = "main" ]; then
  echo "ERROR: Direct commits to main branch are not allowed."
  echo "Please create a feature branch and submit a PR instead."
  echo ""
  echo "To create a feature branch:"
  echo "  git checkout -b feature/your-feature-name"
  exit 1
fi
EOF
    chmod +x .git/hooks/pre-commit
    green "✓ Pre-commit hook installed (prevents commits to main)"
}

# Setup auto-delete merged branches
setup_auto_delete() {
    gh api "repos/$REPO_OWNER/$REPO_NAME" \
        --method PATCH \
        --field delete_branch_on_merge=true \
        --silent
    green "✓ Auto-delete merged branches enabled"
}

# Setup GitHub Actions permissions
setup_actions_permissions() {
    gh api "repos/$REPO_OWNER/$REPO_NAME/actions/permissions/workflow" \
        --method PUT \
        --field default_workflow_permissions=write \
        --field can_approve_pull_request_reviews=true \
        --silent
    green "✓ GitHub Actions PR permissions enabled"
}

# Setup branch protection
setup_branch_protection() {
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
    green "✓ Branch protection enabled (PR-only merges, enforced for admins)"
}

# Main execution
get_repo_info
blue "\nSetting up repository: $REPO_OWNER/$REPO_NAME\n"

create_workflow
create_config
create_manifest
setup_hook

# Always set these repository settings
setup_auto_delete
setup_actions_permissions

if [ "$SKIP_BRANCH_PROTECTION" != "true" ]; then
    setup_branch_protection
fi

green "\n✓ Repository setup complete!\n"
blue "Configuration:"
echo "  Version: $VERSION"
echo "  Release type: $RELEASE_TYPE"
echo "  Branch protection: $([ "$SKIP_BRANCH_PROTECTION" = "true" ] && echo "disabled" || echo "enabled")"
echo ""
yellow "Next steps:"
echo "  1. Commit and push the created files"
echo "  2. Merge to main branch via PR"
echo "  3. release-please will create a release PR automatically"
echo ""
