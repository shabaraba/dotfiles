# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal dotfiles repository for macOS/Linux development environment configuration. Manages shell (zsh), editor (neovim), terminal (wezterm), and AI tool configurations (Claude Code, Cursor).

## Entry Points (エントリーポイント)

| 用途 | コマンド |
|------|----------|
| **初回セットアップ** | `make install` |
| **日常操作** | `mise run deploy`, `mise run dotfiles:update` 等 |

※ `install.sh`や`make deploy`は削除済み。deployer.shは内部スクリプトとして使用。

## Common Commands

### Initial Setup

```bash
git clone https://github.com/shabaraba/dotfiles.git
cd dotfiles
make install
```

OSを自動検出：
- **macOS**: Homebrewパッケージをインストール
- **Ubuntu**: sudo有無を選択してインストーラーを実行
- **その他**: 手動でツールをインストール後、dotfilesをデプロイ

### Daily Operations (mise tasks)

```bash
mise run deploy           # dotfilesを再デプロイ
mise run dotfiles:update  # git pullして再デプロイ
mise run dotfiles:status  # git statusを確認
mise tasks                # 全タスク一覧
make list                 # 管理対象のdotfiles一覧
```

### Homebrew Package Management

Brewfileは2つに分割されています：
- **Brewfile.common**: クロスプラットフォーム対応パッケージ（macOS & Linux）
- **Brewfile.macos**: macOS専用アプリケーション（caskのみ）

```bash
# Cross-platform packages
brew bundle install --file=installers/Brewfile.common
brew bundle check --file=installers/Brewfile.common

# macOS-specific applications
brew bundle install --file=installers/Brewfile.macos  # macOS only
brew bundle check --file=installers/Brewfile.macos    # macOS only

# Update Brewfile after installing new packages
brew bundle dump --force --describe --file=installers/Brewfile.common  # For common packages
brew bundle dump --force --describe --file=installers/Brewfile.macos   # For macOS apps
```

### GitHub Repository Setup (mise tasks)

```bash
mise run gh:repo-init --help             # ヘルプ表示
mise run gh:repo-init                    # フル初期化
mise run gh:repo-init -v 1.0.0 -t node   # バージョン・タイプ指定
mise run gh:repo-init -v 1.0.0 -t go --skip-branch-protection  # ブランチ保護スキップ
```

**CLI Options:**
- `-v, --version <version>` - Initial version (default: `0.1.0`)
- `-t, --release-type <type>` - Project type for release-please (default: `simple`)
- `--skip-branch-protection` - Skip branch protection setup
- `-h, --help` - Show help message

**Valid release types:** simple, node, python, go, rust, ruby, java, php, terraform, helm

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
├── Makefile              # 初回セットアップ用 (make install, make list)
├── deployer.sh           # 内部スクリプト (symlink作成)
├── installers/           # インストーラースクリプト
│   ├── Brewfile          # (DEPRECATED) 分割されたBrewfileへの参照
│   ├── Brewfile.common   # クロスプラットフォーム対応パッケージ
│   ├── Brewfile.macos    # macOS専用GUI アプリケーション
│   ├── ubuntu_installer.sh
│   ├── ubuntu_userspace_installer.sh
│   ├── neovim_installer.sh
│   └── zsh_installer.sh
├── sh/                   # シェル設定
│   ├── .zshrc, .zshenv, .zprofile
│   └── zsh/              # モジュラー設定
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
├── terminal/
│   ├── wezterm/          # WezTerm terminal config (→ ~/.config/wezterm)
│   └── ghostty/          # Ghostty terminal config (→ ~/.config/ghostty)
└── cursor/cursorrules    # Cursor IDE rules (→ ~/.cursorrules)
```

## Key Architecture

### Symlink Strategy

deployer.shがシンボリックリンクを作成：
- Shell configs → `~/.zshrc`, `~/.zshenv`, `~/.zsh/`
- Neovim → `~/.config/nvim`
- Claude Code → `~/.claude/`
- mise → `~/.config/mise/config.toml`
- WezTerm → `~/.config/wezterm`
- Ghostty → `~/.config/ghostty`

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
3. If Homebrew package:
   - Add to `installers/Brewfile.common` for cross-platform tools
   - Add to `installers/Brewfile.macos` for macOS-specific GUI apps (cask)
4. Run `mise run deploy` to apply changes

## Code Style Guidelines

- **Languages**: Lua (Neovim), Shell script (zsh/bash)
- **Lua style**: Use lowercase_with_underscores for variables/functions, CamelCase for modules
- **Shell style**: Use sh/bash compatible syntax where possible
- **File organization**: Keep configurations modular and organized by function
- **Comments**: Use -- for Lua, # for shell scripts
- **Indentation**: 2 spaces for Lua, 4 spaces for shell scripts
- **Error handling**: Check return codes and file existence before operations
- **Imports**: Use `require()` for Lua modules, `source` for shell scripts

## Testing/Validation

- No automated tests exist; test manually after changes
- Validate shell scripts with `shellcheck` when possible
- Test Neovim configs with `:checkhealth` command after changes

## Git Guidelines

- Use Semantic Commit Messages (feat, fix, chore, test, refactor)
- Commit messages in English only
- Create branches for features (never commit to main directly)
- Owner: shabaraba

## Notes

- Global Claude Code rules are maintained in `claude/CLAUDE.md`
- Custom Claude agents are defined in `claude/agents/`
- Custom slash commands are in `claude/commands/`
