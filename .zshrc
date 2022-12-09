# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"

[[ -f "$HOME/.zsh/public/export.zsh" ]] && source ~/.zsh/public/export.zsh
[[ -f "$HOME/.zsh/public/alias.zsh" ]] && source ~/.zsh/public/alias.zsh
[[ -f "$HOME/.zsh/public/setopt.zsh" ]] && source ~/.zsh/public/setopt.zsh
[[ -f "$HOME/.zsh/public/prompt.zsh" ]] && source ~/.zsh/public/prompt.zsh
[[ -f "$HOME/.zsh/private/alias.zsh" ]] && source ~/.zsh/private/alias.zsh
[[ -f "$HOME/.zsh/private/env.zsh" ]] && source ~/.zsh/private/env.zsh
 
# zsh-completions
autoload -U compinit && compinit -u
 
# git
git config --global color.ui auto 
 
# docker
de () {docker exec -it $1 zsh}

autoload -Uz colors
colors
 
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
 
bindkey -d
bindkey -e
 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# for genie (run systemctl as root)
# wsl$B$+$I$&$+(B
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    echo "in wsl"
    #genie(systemd$B$r(Bwsl$B$G;HMQ$G$-$k$h$&$K$9$k(B)$B$r5/F0$9$k$+$I$&$+(B
    if [ "`ps -eo pid,cmd | grep systemd | grep -v grep | sort -n -k 1 | awk 'NR==1 { print $1 }'`" != "1" ]; then
      echo "genie is running..."
      genie -s
    fi
fi

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
#
# load zinit plugins
source ~/.zsh/zinit/plugins.zsh
