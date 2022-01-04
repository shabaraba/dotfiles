export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# zplug$B$NFI$_9~$_!&=i4|2=(B
if [ -f ~/.zplug/init.zsh ]; then
else
	if [ -d ~/.zplug ]; then
	else
		mkdir ~/.zplug
	fi
	git clone https://github.com/zplug/zplug ~/.zplug
fi

export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
source ~/.zplug/init.zsh

########################
# zplug setting
########################
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# theme ( https://github.com/sindresorhus/pure#zplug)$B!!9%$_$N%9%-!<%^$r$$$l$F$/$@$5$l!#(B
#zplug mafredri/zsh-async, from:github
#zplug caiogondim/bullet-train.zsh, use:bullet-train.zsh-theme, from:github, as:theme
#setopt prompt_subst # Make sure prompt is able to be generated properly.
#zplug caiogondim/bullet-train.zsh, from:github, use:bullet-train.zsh-theme, as:theme  # defer until other plugins like oh-my-zsh is loaded
#zplug "caiogondim/bullet-train.zsh", use:bullet-train.zsh-theme, as:theme, defer:3 # defer until other plugins like oh-my-zsh is loaded

# $B9=J8$N%O%$%i%$%H(B(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history$B4X78(B
#zplug "zsh-users/zsh-history-substring-search"
# $B%?%$%WJd40(B
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
#zplug "chrissicool/zsh-256color"

# z$B$G%U%)%k%@0\F0(B
zplug "rupa/z"
. ~/.zplug/repos/rupa/z/z.sh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
# Then, source plugins and add commands to $PATH
zplug load


########################
# end zplug setting
########################
export PATH=/usr/bin/node:$PATH

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
