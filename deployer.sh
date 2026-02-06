echo "🚚 deploy dotfiles and configs..."
echo "  - 🚚 to ~"
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

echo "  - 🚚 for AI✨️"
mkdir -p $HOME/.claude
ln -snfv $PWD/claude/CLAUDE.md $HOME/.claude/CLAUDE.md
ln -snfv $PWD/claude/settings.json $HOME/.claude/settings.json
ln -snfv $PWD/claude/commands $HOME/.claude/commands
ln -snfv $PWD/claude/agents $HOME/.claude/agents
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
# Link shared skills
ln -snfv $PWD/claude/skills/shared $HOME/.claude/skills/shared
ln -snfv $PWD/cursor/cursorrules $HOME/.cursorrules
# geminiディレクトリが存在しない場合はスキップ
if [ -d "$PWD/gemini" ]; then
  mkdir -p $HOME/.gemini
  ln -snfv $PWD/gemini/settings.json $HOME/.gemini/settings.json
  ln -snfv $PWD/gemini/commands $HOME/.gemini/commands
fi

echo "🎉 deploy finished."
