# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
[[ -f "$HOME/.zsh/public/export.zsh" ]] && source ~/.zsh/public/export.zsh
[[ -f "$HOME/.zsh/public/alias.zsh" ]] && source ~/.zsh/public/alias.zsh
[[ -f "$HOME/.zsh/public/setopt.zsh" ]] && source ~/.zsh/public/setopt.zsh
[[ -f "$HOME/.zsh/public/prompt.zsh" ]] && source ~/.zsh/public/prompt.zsh
[[ -f "$HOME/.zsh/private/alias.zsh" ]] && source ~/.zsh/private/alias.zsh
[[ -f "$HOME/.zsh/private/env.zsh" ]] && source ~/.zsh/private/env.zsh
[[ -f "$HOME/.zsh/contexts/git.zsh" ]] && source ~/.zsh/contexts/git.zsh
[[ -f "$HOME/.zsh/contexts/docker.zsh" ]] && source ~/.zsh/contexts/docker.zsh

autoload -Uz colors
colors
 
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
 
# zsh-completions
autoload -U compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"

### Added by Zinit's installer
[[ -f "$HOME/.zsh/zinit/zinit.zsh" ]] && source ~/.zsh/zinit/zinit.zsh
