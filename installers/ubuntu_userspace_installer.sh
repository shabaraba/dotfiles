#!/usr/bin/env bash

set -e

echo "🚀 Installing tools via Homebrew (no sudo required)..."

# Install Homebrew if not present
echo "🍺 Checking Homebrew installation..."
if ! command -v brew &> /dev/null; then
    echo "📥 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for current session
    if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    echo "✅ Homebrew installed"
else
    echo "✓ Homebrew already installed"
fi

# Install packages from Brewfile.common (cross-platform packages only)
echo "📦 Installing packages from Brewfile.common..."
BREWFILE_COMMON="$(dirname "$0")/Brewfile.common"

if [[ -f "$BREWFILE_COMMON" ]]; then
    brew bundle install --file="$BREWFILE_COMMON"
    echo "✅ All packages installed from Brewfile.common"
else
    echo "⚠️  Brewfile.common not found at $BREWFILE_COMMON"
    exit 1
fi

echo ""
echo "✅ Ubuntu user space setup complete!"
echo ""
echo "Installed via Homebrew:"
command -v mise &> /dev/null && echo "  ✓ mise: $(command -v mise)"
command -v zoxide &> /dev/null && echo "  ✓ zoxide: $(command -v zoxide)"
command -v lsd &> /dev/null && echo "  ✓ lsd: $(command -v lsd)"
command -v nvim &> /dev/null && echo "  ✓ neovim: $(command -v nvim)"
command -v sheldon &> /dev/null && echo "  ✓ sheldon: $(command -v sheldon)"
echo ""
echo "⚠️  Note: Ghostty terminal is not installed via Homebrew on Linux"
echo "   To install Ghostty, run: bash installers/ubuntu_installer.sh"
echo "   (Homebrew cask 'ghostty' is macOS only)"
echo ""
echo "Next steps:"
echo "  1. Run 'source ~/.zshrc' to load new tools"
echo "  2. Or logout and login again to apply changes"
echo ""
