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
ln -snfv $PWD/sh/zsh/sheldon $HOME/.config/sheldon

echo "  - 🚚 for AI✨️"
mkdir -p $HOME/.claude
ln -snfv $PWD/claude/CLAUDE.md $HOME/.claude/CLAUDE.md
ln -snfv $PWD/claude/settings.json $HOME/.claude/settings.json
ln -snfv $PWD/claude/commands $HOME/.claude/commands
ln -snfv $PWD/claude/agents $HOME/.claude/agents
ln -snfv $PWD/cursor/cursorrules $HOME/.cursorrules
# geminiディレクトリが存在しない場合はスキップ
if [ -d "$PWD/gemini" ]; then
  mkdir -p $HOME/.gemini
  ln -snfv $PWD/gemini/settings.json $HOME/.gemini/settings.json
  ln -snfv $PWD/gemini/commands $HOME/.gemini/commands
fi

echo "🎉 deploy finished."
