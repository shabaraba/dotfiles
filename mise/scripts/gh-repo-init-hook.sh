#!/usr/bin/env bash
set -e

# Setup pre-commit hook to prevent commits to main
# This script is part of gh:repo-init task suite

if [ ! -d .git/hooks ]; then
    echo "Error: .git directory not found. Make sure you are in a git repository."
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
echo "✓ Pre-commit hook installed (prevents commits to main)"
