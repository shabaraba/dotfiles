#!/usr/bin/env bash
set -e

# Create release-please configuration files only
# This script is part of gh:repo-init task suite

# Color output functions
green() { echo -e "\033[32m$1\033[0m"; }
red() { echo -e "\033[31m$1\033[0m"; }

# Show help message
show_help() {
    cat <<'HELP'
Usage: mise run gh:repo-init:config [OPTIONS]

Create release-please configuration files only.

Options:
  -v, --version <version>        Initial version (default: 0.1.0)
  -t, --release-type <type>      Release type (default: simple)
  -h, --help                     Show this help message

Valid release types:
  simple, node, python, go, rust, ruby, java, php, terraform, helm

Use 'mise run gh:repo-init --help' for detailed information.
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
    echo "Valid types: simple, node, python, go, rust, ruby, java, php, terraform, helm"
    exit 1
}

# Default options
VERSION="${VERSION:-0.1.0}"
RELEASE_TYPE="${RELEASE_TYPE:-simple}"

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
        *)
            red "Error: Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Validate release type
validate_release_type "$RELEASE_TYPE"

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

cat > .release-please-manifest.json <<EOF
{
  ".": "$VERSION"
}
EOF

green "✓ Created release-please-config.json (release-type: $RELEASE_TYPE)"
green "✓ Created .release-please-manifest.json (v$VERSION)"
