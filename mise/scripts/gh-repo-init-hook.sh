#!/usr/bin/env bash
set -e

# Setup pre-commit hook to prevent commits to main
# This script is part of gh:repo-init task suite

# Resolve the git hooks directory
HOOKS_DIR=$(git rev-parse --git-path hooks 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$HOOKS_DIR" ]; then
    echo "Error: Not in a git repository or unable to resolve hooks directory."
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

cat > "$HOOKS_DIR/pre-commit" <<'EOF'
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

chmod +x "$HOOKS_DIR/pre-commit"
echo "✓ Pre-commit hook installed (prevents commits to main)"
