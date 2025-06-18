echo "🚚 deploy dotfiles and configs..."
echo "  - 🚚 to ~"
ln -snfv $PWD/sh/zsh $HOME/.zsh
ln -snfv $PWD/sh/zsh/public/p10k.zsh $HOME/.p10k.zsh

ln -snfv $PWD/sh/.zshrc $HOME/.zshrc
ln -snfv $PWD/sh/.zshenv $HOME/.zshenv
ln -snfv $PWD/sh/.zprofile $HOME/.zprofile

ln -snfv $PWD/vim/.ideavimrc $HOME/.ideavimrc

echo "  - 🚚 to ~/.config/"
ln -snfv $PWD/nvim $HOME/.config
ln -snfv $PWD/zabrze $HOME/.config
ln -snfv $PWD/terminal/wezterm $HOME/.config
ln -snfv $PWD/sh/zsh/sheldon $HOME/.config

ln -snfv $PWD/claude/CLAUDE.md $HOME/.claude/CLAUDE.md
ln -snfv $PWD/claude/settings.json $HOME/.claude/settings.json
ln -snfv $PWD/claude/commands $HOME/.claude/commands
ln -snfv $PWD/cursor/cursorrules $HOME/.cursorrules

echo "🎉 deploy finished."
