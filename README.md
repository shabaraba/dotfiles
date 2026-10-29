
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
- mise 管理の開発 CLI をインストール

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
- `mise run tools:update` - mise・Homebrew・sheldon の更新を順に実行
- `mise run tools:install` - mise 管理の開発 CLI をインストール
- `mise run tools:migrate` - 移行先を確認して重複インストールを削除（Homebrew の依存は保持）
- `mise run brew:update` - Brewfile の未導入パッケージを導入し、HEAD 版を含む Homebrew パッケージを更新
- `mise run brew:dump` - `installers/Brewfile.snapshot` に確認用一覧を出力
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

開発 CLI は `mise/config.toml`、システム周辺は `installers/Brewfile.common`、
macOS アプリは `installers/Brewfile.macos` で管理します。
`installers/Brewfile` は互換用の読み込み口です。

- mise: Node、Python、Go、pnpm、Deno、gh、ripgrep、各種 CLI・フォーマッター
- mise の pypi バックエンド: graphifyy、mlx-lm、mlx-vlm（MLX は Apple Silicon のみ）
- Homebrew: mise 本体、シェル、Neovim、sheldon、Docker/Colima、Ruby、Rust、Java、アプリ

Java は既存の証明書設定、Ruby は CocoaPods/fastlane との連携を維持します。
sheldon は zsh プラグインの読み込みを担当し、更新は `tools:update` に含まれます。
`tools:update` は Brewfile の未導入パッケージ（Gitea・tea など）も導入し、
Neovim などの HEAD 版は上流の更新を確認します。Neovim は HEAD 版を指定しています。
mise の更新は `--no-prune` で旧バージョンを保持します。Python CLI の参照先を
削除しないよう、古い環境の整理は更新と分けて行います。
Neovim のプラグインは別途 `:Lazy update` で更新してください。

移行後はシェルを再起動してください。Homebrew の依存として残る CLI は、
通常のシェルでは mise 側を優先します。古い uv tool 環境を直接参照する外部設定が
あれば、mise の shim または `mise exec -- <command>` を参照するよう変更してください。

Python CLI は移行時のバージョンをインストールし、次回の `tools:update` から更新します。
Terraform は既存の 1.5.7 を維持し、Python は 3.13 系、Yarn は 1.22 系を使います。
指定範囲を越える更新は、内容を確認して `mise use -g <tool>@<version>` で行います。

## NOTICE

if you use not `.vimspector.json` in your project root
but configuration files in .vimspector-config/\* to debug,
you have to set your project root to `/var/www/html/src`
and launch neovim in your project root
because we set path-mapping as belows in the configuration file.

```json
{"/var/www/html/src": "${cwd}"}
```
