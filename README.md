
# .dotfiles

Personal dotfiles configuration for development environment setup.

## Entry Points (簡潔なエントリーポイント)

| 用途 | コマンド |
|------|----------|
| **初回セットアップ** | `make install` |
| **日常操作（deploy等）** | `mise run deploy`, `mise run dotfiles:update` 等 |

## Quick Start

### 1. Initial Setup (初回のみ)

```sh
git clone https://github.com/shabaraba/dotfiles.git
cd dotfiles
make install
```

OSを自動検出し、以下を実行します：
- **macOS**: Homebrewパッケージをインストール
- **Ubuntu**: sudo有無を選択してインストーラーを実行
- dotfilesをホームディレクトリにデプロイ

### 2. Restart Shell

```sh
exec $SHELL -l
```

### 3. Daily Operations (日常操作)

インストール後は**mise tasks**を使用します：

```sh
mise run deploy           # dotfilesを再デプロイ
mise run dotfiles:update  # git pullして再デプロイ
mise run dotfiles:status  # git statusを確認
mise tasks                # 全タスク一覧
```

## Security Notice

⚠️ 使用前にプライベート設定を構成してください：

```sh
cp sh/zsh/private/env.zsh.example sh/zsh/private/env.zsh
cp sh/zsh/private/alias.zsh.example sh/zsh/private/alias.zsh
```

プレースホルダーを実際の値に更新してください。

## Available mise Tasks

### Dotfiles Management
- `mise run deploy` - Deploy dotfiles symlinks
- `mise run dotfiles:update` - Update from git and redeploy
- `mise run dotfiles:status` - Show git status

### System Maintenance
- `mise run brew:update` - Update Homebrew and all packages
- `mise run brew:dump` - Update Brewfile with installed packages
- `mise run brew:check` - Check if all Brewfile packages are installed
- `mise run cache:clean` - Clean system caches

### Utilities
- `mise run myip` - Show public IP address
- `mise run ports` - List all listening ports
- `mise run dns:flush` - Flush DNS cache (macOS)
- `mise run git:cleanup` - Delete merged git branches
- `mise run sysinfo` - Show system information

### GitHub Repository Setup
- `mise run gh:repo-init` - Initialize repository with release-please
- `mise run gh:repo-init --help` - Show detailed options

Run `mise tasks` to see all available tasks with descriptions.

## Brewfile Management

Brewfile is located in `installers/Brewfile`. Categories include:
- **System Tools**: bash, gnu-sed, wget
- **Development Tools**: mise, openjdk, gh, jq, ripgrep
- **Shell & CLI Enhancement**: sheldon, zoxide, neovim
- **GUI Applications**: claude-code, jetbrains-toolbox, wezterm

## NOTICE

if you use not `.vimspector.json` in your project root
but configuration files in .vimspector-config/\* to debug,
you have to set your project root to `/var/www/html/src`
and launch neovim in your project root
because we set path-mapping as belows in the configuration file.

```json
{"/var/www/html/src": "${cwd}"}
```
