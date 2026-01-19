#!/usr/bin/env bash
set -e

# Create release-please workflow file only
# This script is part of gh:repo-init task suite

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

echo "✓ Created .github/workflows/release-please.yml"
