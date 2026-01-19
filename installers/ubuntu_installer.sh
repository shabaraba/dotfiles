#!/usr/bin/env bash

set -e

echo "🚀 Starting Ubuntu development environment setup..."

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install basic dependencies
echo "📦 Installing basic dependencies..."
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    software-properties-common

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

# Install packages from Brewfile
echo "📦 Installing packages from Brewfile..."
BREWFILE_PATH="$(dirname "$0")/Brewfile"

if [[ -f "$BREWFILE_PATH" ]]; then
    brew bundle install --file="$BREWFILE_PATH"
    echo "✅ All packages installed from Brewfile"
else
    echo "⚠️  Brewfile not found at $BREWFILE_PATH"
    exit 1
fi

# Install Ghostty terminal
echo "👻 Installing Ghostty terminal..."
if ! command -v ghostty &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
else
    echo "✓ ghostty already installed"
fi

echo ""
echo "✅ Ubuntu development environment setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'make deploy' to create symlinks"
echo "  2. Change default shell: chsh -s $(which zsh)"
echo "  3. Logout and login again to apply changes"
echo ""
