#!/bin/bash
# Bootstrap script for fresh macOS/Linux setup
# This script only runs once for initial setup

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Starting dotfiles installation..."
echo "DOTFILES_DIR: $DOTFILES_DIR"

# Function to install Homebrew
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for this session
        if [[ $(uname -m) == 'arm64' ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo "✅ Homebrew already installed"
    fi
}

# Function to install packages from Brewfile (includes mise)
install_packages() {
    echo "📦 Installing packages from Brewfile (including mise)..."
    brew bundle install --file="$DOTFILES_DIR/installers/Brewfile"
}

# Function to install Neovim configuration
install_neovim() {
    if [ -f "$DOTFILES_DIR/installers/neovim_installer.sh" ]; then
        echo "🔧 Installing Neovim configuration..."
        sh "$DOTFILES_DIR/installers/neovim_installer.sh"
    fi
}

# Function to install Zsh configuration
install_zsh() {
    if [ -f "$DOTFILES_DIR/installers/zsh_installer.sh" ]; then
        echo "🐚 Installing Zsh configuration..."
        sh "$DOTFILES_DIR/installers/zsh_installer.sh"
    fi
}

# Function to deploy dotfiles
deploy_dotfiles() {
    echo "🔗 Deploying dotfiles..."
    sh "$DOTFILES_DIR/deployer.sh"
}

# Main installation flow
main() {
    install_homebrew
    install_packages
    install_neovim
    install_zsh
    deploy_dotfiles

    echo ""
    echo "✨ Installation complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your shell or run: exec \$SHELL -l"
    echo "  2. Available mise tasks:"
    echo "     - mise run deploy           # Redeploy dotfiles"
    echo "     - mise run dotfiles:update  # Update from git and redeploy"
    echo "     - mise run brew:update      # Update Homebrew packages"
    echo "     - mise tasks                # List all available tasks"
}

main "$@"
