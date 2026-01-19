# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal dotfiles repository for macOS/Linux development environment configuration. Manages shell (zsh), editor (neovim), terminal (wezterm), and AI tool configurations (Claude Code, Cursor).

## Common Commands

```bash
# Initial setup (first time only)
make install

# Deploy dotfiles to home directory (creates symlinks)
make deploy

# List managed dotfiles
make list
```

### Homebrew Package Management
```bash
# Install all packages from Brewfile
brew bundle install --file=installers/Brewfile

# Update Brewfile with currently installed packages
brew bundle dump --force --describe --file=installers/Brewfile

# Check if all packages are installed
brew bundle check --file=installers/Brewfile
```

### GitHub Repository Setup (mise tasks)
Available globally after deploying dotfiles (`make deploy`):

```bash
# Show help message
mise run gh:repo-init --help

# Full repository initialization (all-in-one, default settings)
mise run gh:repo-init

# Using CLI arguments (recommended)
mise run gh:repo-init --version 1.0.0 --release-type node
mise run gh:repo-init -v 2.0.0 -t python
mise run gh:repo-init -v 1.0.0 -t go --skip-branch-protection

# Using environment variables (also supported)
VERSION=1.0.0 mise run gh:repo-init
RELEASE_TYPE=node mise run gh:repo-init
VERSION=1.0.0 RELEASE_TYPE=rust mise run gh:repo-init

# Individual setup tasks (modular approach)
mise run gh:repo-init:workflow  # Create release-please workflow only
mise run gh:repo-init:config --help  # Show help for config task
mise run gh:repo-init:config -v 1.0.0 -t node  # Create config files only
mise run gh:repo-init:hook      # Setup pre-commit hook only
mise run gh:repo-init:protect   # Setup GitHub protection settings only
```

**CLI Options:**
- `-v, --version <version>` - Initial version (default: `0.1.0`)
- `-t, --release-type <type>` - Project type for release-please (default: `simple`)
- `--skip-branch-protection` - Skip branch protection setup
- `-h, --help` - Show help message

**Valid release types:**
- `simple` - Generic projects (language-agnostic)
- `node` - Node.js/JavaScript/TypeScript
- `python` - Python
- `go` - Go
- `rust` - Rust
- `ruby` - Ruby
- `java` - Java
- `php` - PHP
- `terraform` - Terraform
- `helm` - Helm charts

**Environment variables** (alternative to CLI options):
- `VERSION` - Same as `--version`
- `RELEASE_TYPE` - Same as `--release-type`
- `SKIP_BRANCH_PROTECTION` - Set to `true` to skip branch protection

**What `gh:repo-init` does:**
1. Creates `.github/workflows/release-please.yml` for automated releases
2. Creates `release-please-config.json` with semantic versioning setup
3. Creates `.release-please-manifest.json` with initial version
4. Installs pre-commit hook to prevent direct commits to main
5. Enables auto-delete of merged branches on GitHub
6. Grants GitHub Actions permission to create PRs
7. Sets up branch protection (PR-required, enforced for admins)

## Repository Structure

```
dotfiles/
├── Makefile              # Installation and deployment automation
├── deployer.sh           # Symlink creation script
├── installers/           # Installation scripts
│   ├── Brewfile          # Homebrew package definitions
│   ├── neovim_installer.sh
│   └── zsh_installer.sh
├── sh/                   # Shell configuration
│   ├── .zshrc            # Main zsh config (→ ~/.zshrc)
│   ├── .zshenv           # Environment variables (→ ~/.zshenv)
│   └── zsh/              # Modular zsh configs
│       ├── public/       # Public configs (alias, prompt, etc.)
│       ├── private/      # Private configs (API keys, tokens)
│       ├── sheldon/      # Plugin manager configuration
│       └── contexts/     # Context-specific settings (git, docker)
├── nvim/                 # Neovim configuration (→ ~/.config/nvim)
│   ├── init.lua          # Entry point
│   └── lua/
│       ├── core/         # Core settings (autocmds, lsp)
│       └── plugins/      # Plugin configurations by category
├── claude/               # Claude Code configuration (→ ~/.claude/)
│   ├── CLAUDE.md         # Global Claude rules (→ ~/.claude/CLAUDE.md)
│   ├── settings.json     # Claude settings
│   ├── agents/           # Custom agent definitions
│   └── commands/         # Custom slash commands
├── mise/                 # mise task manager configuration
│   └── config.toml       # Global tasks (→ ~/.config/mise/config.toml)
├── terminal/wezterm/     # WezTerm terminal config
└── cursor/cursorrules    # Cursor IDE rules (→ ~/.cursorrules)
```

## Key Architecture

### Symlink Strategy
The `deployer.sh` script creates symlinks from this repo to home directory:
- Shell configs → `~/.zshrc`, `~/.zshenv`, `~/.zsh/`
- Neovim → `~/.config/nvim`
- Claude Code → `~/.claude/`
- mise → `~/.config/mise/config.toml`
- WezTerm → `~/.config/wezterm`

### Shell Configuration
- **Plugin Manager**: sheldon (configured in `sh/zsh/sheldon/`)
- **Prompt**: Powerlevel10k with instant prompt
- **Runtime Manager**: mise (replaces nvm, rbenv, pyenv)
- **Directory Navigation**: zoxide

### Neovim Configuration
- **Plugin Manager**: lazy.nvim
- **LSP**: mason.nvim + nvim-lspconfig
- **AI Integration**: Copilot, Claude Code integration
- Plugins organized by category: `core/`, `ui/`, `action/`, `coding/`, `ai/`

### Private Configuration
Private settings (API keys, tokens) are stored in `sh/zsh/private/` and excluded from git:
1. Copy example files: `*.example` → remove `.example` suffix
2. Fill in actual values for placeholders

## Adding New Configurations

1. Add config files to appropriate directory
2. Update `deployer.sh` to create symlinks
3. If Homebrew package, add to `installers/Brewfile`
4. Run `make deploy` to apply changes

## Notes

- Global Claude Code rules are maintained in `claude/CLAUDE.md`
- Custom Claude agents are defined in `claude/agents/`
- Custom slash commands are in `claude/commands/`
