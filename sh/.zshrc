# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -f "$HOME/.zsh/public/export.zsh" ]] && source ~/.zsh/public/export.zsh
[[ -f "$HOME/.zsh/public/abbr.zsh" ]] && source ~/.zsh/public/abbr.zsh
[[ -f "$HOME/.zsh/public/alias.zsh" ]] && source ~/.zsh/public/alias.zsh
[[ -f "$HOME/.zsh/public/setopt.zsh" ]] && source ~/.zsh/public/setopt.zsh
[[ -f "$HOME/.zsh/public/prompt.zsh" ]] && source ~/.zsh/public/prompt.zsh
[[ -f "$HOME/.zsh/private/abbr.zsh" ]] && source ~/.zsh/private/abbr.zsh
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

### Added by Zinit's installer
[[ -f "$HOME/.zsh/zinit/zinit.zsh" ]] && source ~/.zsh/zinit/zinit.zsh

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
