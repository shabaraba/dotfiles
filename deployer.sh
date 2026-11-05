cd "$(dirname "$0")" || exit 1

echo "🚚 deploy dotfiles and configs..."
echo "  - 🚚 to ~"
ln -snfv $PWD $HOME/.dotfiles
ln -snfv $PWD/sh/zsh $HOME/.zsh
ln -snfv $PWD/sh/zsh/public/p10k.zsh $HOME/.p10k.zsh

ln -snfv $PWD/sh/.zshrc $HOME/.zshrc
ln -snfv $PWD/sh/.zshenv $HOME/.zshenv
ln -snfv $PWD/sh/.zprofile $HOME/.zprofile

ln -snfv $PWD/vim/.ideavimrc $HOME/.ideavimrc

echo "  - 🚚 to ~/.config/"
mkdir -p $HOME/.config
ln -snfv $PWD/nvim $HOME/.config/nvim
# ln -snfv $PWD/zabrze $HOME/.config/zabrze  # コメントアウト：ディレクトリが存在しない
ln -snfv $PWD/terminal/wezterm $HOME/.config/wezterm
ln -snfv $PWD/terminal/ghostty $HOME/.config/ghostty
ln -snfv $PWD/sh/zsh/sheldon $HOME/.config/sheldon
mkdir -p $HOME/.config/mise
ln -snfv $PWD/mise/config.toml $HOME/.config/mise/config.toml
if [ -f "$PWD/mise/conf.d/local.toml" ]; then
  mkdir -p $HOME/.config/mise/conf.d
  ln -snfv $PWD/mise/conf.d/local.toml $HOME/.config/mise/conf.d/local.toml
fi
mkdir -p $HOME/.config/git
ln -snfv $PWD/git/config $HOME/.config/git/config
ln -snfv $PWD/git/ignore $HOME/.config/git/ignore
if [ -f "$PWD/git/config.local" ]; then
  ln -snfv $PWD/git/config.local $HOME/.config/git/config.local
fi

echo "  - 🚚 for AI✨️"
mkdir -p $HOME/.claude
ln -snfv $PWD/claude/CLAUDE.md $HOME/.claude/CLAUDE.md
ln -snfv $PWD/claude/settings.json $HOME/.claude/settings.json
ln -snfv $PWD/claude/statusline.sh $HOME/.claude/statusline.sh
ln -snfv $PWD/claude/commands $HOME/.claude/commands
ln -snfv $PWD/claude/agents $HOME/.claude/agents
ln -snfv $PWD/claude/hooks $HOME/.claude/hooks
ln -snfv $PWD/claude/rules $HOME/.claude/rules
mkdir -p $HOME/.claude/skills
# Link private skills directly to ~/.claude/skills/ (not as subdirectory)
if [ -d "$PWD/claude/skills/private" ]; then
  for skill_dir in $PWD/claude/skills/private/*/; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")
      ln -snfv "$skill_dir" "$HOME/.claude/skills/$skill_name"
    fi
  done
fi
# Link agent-agnostic skills to ~/.claude/skills/ and ~/.agents/skills/
# (~/.agents/skills is read by Codex, Grok and Command Code)
mkdir -p $HOME/.agents/skills
for skill_dir in $PWD/agents/skills/*/; do
  if [ -d "$skill_dir" ]; then
    skill_name=$(basename "$skill_dir")
    ln -snfv "$skill_dir" "$HOME/.claude/skills/$skill_name"
    ln -snfv "$skill_dir" "$HOME/.agents/skills/$skill_name"
  fi
done
# Link Claude-only personal skills (claude/skills/* excluding private)
for skill_dir in $PWD/claude/skills/*/; do
  skill_name=$(basename "$skill_dir")
  if [ "$skill_name" != "private" ]; then
    ln -snfv "$skill_dir" "$HOME/.claude/skills/$skill_name"
  fi
done
ln -snfv $PWD/cursor/cursorrules $HOME/.cursorrules
# geminiディレクトリが存在しない場合はスキップ
if [ -d "$PWD/gemini" ]; then
  mkdir -p $HOME/.gemini
  ln -snfv $PWD/gemini/settings.json $HOME/.gemini/settings.json
  ln -snfv $PWD/gemini/commands $HOME/.gemini/commands
fi

echo "  - 🚚 for Command Code"
mkdir -p $HOME/.commandcode
# Command Code rewrites these atomically (temp file + rename), which replaces a symlink.
# Keep the source in dotfiles and deploy copies; edit here and re-run deploy.
install -m 600 $PWD/.commandcode/settings.json $HOME/.commandcode/settings.json
install -m 600 $PWD/.commandcode/config.json $HOME/.commandcode/config.json

echo "  - 🔒 package manager security settings"
command -v npm >/dev/null 2>&1 && npm config set ignore-scripts true --user
command -v yarn >/dev/null 2>&1 && yarn config set enableScripts false
# Takumi Guard: 匿名でも悪性パッケージのブロックは有効（トークンがあれば追跡・通知も有効）
if command -v npm >/dev/null 2>&1; then
  npm config set registry https://npm.flatt.tech/ --user
  if [ -n "${TAKUMI_GUARD_API_KEY:-}" ]; then
    npm config set //npm.flatt.tech/:_authToken "$TAKUMI_GUARD_API_KEY" --user
  fi
fi
if command -v pnpm >/dev/null 2>&1; then
  # pnpm refuses global config writes unless its global bin dir is on PATH
  [ -n "${PNPM_HOME:-}" ] && export PATH="$PNPM_HOME:$PATH"
  pnpm config set -g registry https://npm.flatt.tech/
  pnpm config set -g minimumReleaseAge 1440
  pnpm config set -g --json minimumReleaseAgeExclude '["@anthropic-ai/claude-code"]'
fi

echo "🎉 deploy finished."
