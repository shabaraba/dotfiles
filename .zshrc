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

### Added by Zinit's installer
[[ -f "$HOME/.zsh/zinit/zinit.zsh" ]] && source ~/.zsh/zinit/zinit.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"

# nvm での node version 自動切り替え設定
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
