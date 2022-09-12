# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH=/usr/bin/node:$PATH
typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
)

 #load settings
source ~/.zsh/prompt.zsh


PROMPT='%~ %# '
 
# zsh-completions
autoload -U compinit && compinit -u
 
# git
git config --global color.ui auto 
 
alias ls='ls -GF --color'

alias his='history'
alias ...='cd ../..'
alias ....='cd ../../..'
alias e="emacs"
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias mss='mysql.server start'
alias so='source'
alias be='bundle exec'
alias ber='bundle exec ruby'
 
alias g='git'
alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gct='git commit'
alias gg='git grep'
alias ga='git add'
alias gd='git diff'
alias gl='git log'
alias gla='git log --graph --all --decorate'
alias gcma='git checkout main'
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias gmod='git merge origin/develop'
alias gmud='git merge upstream/develop'
alias gmom='git merge origin/master'
alias gcm='git commit -m'
alias gpo='git push origin'
alias gpom='git push origin master'
alias gst='git stash'
alias gsl='git stash list'
alias gsu='git stash -u'
alias gsp='git stash pop'

# docker
alias dc='docker-compose'
alias dp='docker ps'
de () {docker exec -it $1 zsh}

# for file
case ${OSTYPE} in
  darwin*)
    # ここに Mac 向けの設定
    alias open='open'
    ;;
  linux*)
    alias open='xdg-open'
    # ここに Linux 向けの設定
    ;;
esac
 
autoload -Uz colors
colors
 
setopt print_eight_bit
 
setopt auto_cd
 
setopt no_beep
 
setopt nolistbeep
 
setopt auto_pushd
 
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
 
setopt share_history
 
setopt hist_ignore_dups
 
setopt hist_ignore_all_dups
 
setopt hist_ignore_space
 
setopt hist_reduce_blanks
 
bindkey -d
bindkey -e
 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
zstyle ':completion:*:default' menu select=1
 
setopt correct
 
setopt auto_pushd
 
setopt pushd_ignore_dups
 
setopt extended_glob

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
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:/usr/local/opt/mysql-client@5.7/bin"

# nodenv
[[ -d ~/.nodenv  ]] && \
    export PATH="$HOME/.nodenv/bin:$PATH" && \
    eval "$(nodenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export ANDROID_SDK_ROOT=$HOME/.android
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools:$PATH
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$PATH
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools/lib:$PATH
export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
export PATH=$ANDROID_SDK_ROOT/emulator:$PATH

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# export FLUTTER_ROOT=$HOME/Flutter/Sdk
# export PATH=$FLUTTER_ROOT/bin:$PATH

# android device bridgh
# wsl2ではusb接続されたデバイスを認識できず、実機デバッグしにくいので、
# windowsのadbを使用する（rootにadbという名前でwindowsのadb.exeにシンボリックリンクを張っている）
# alias adb='~/adb'
alias adb='/mnt/d/tools/platform-tools/adb.exe'
alias flutter='/mnt/c/flutter/bin/flutter'
alias dart='/mnt/c/flutter/bin/dart'


# phpenv
export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"
export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"

# load private environment settings
source ~/.zsh/env.zsh

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
