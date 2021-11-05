export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# zplugの読み込み・初期化
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
# theme ( https://github.com/sindresorhus/pure#zplug)　好みのスキーマをいれてくだされ。
#zplug mafredri/zsh-async, from:github
#zplug caiogondim/bullet-train.zsh, use:bullet-train.zsh-theme, from:github, as:theme
#setopt prompt_subst # Make sure prompt is able to be generated properly.
#zplug caiogondim/bullet-train.zsh, from:github, use:bullet-train.zsh-theme, as:theme  # defer until other plugins like oh-my-zsh is loaded
#zplug "caiogondim/bullet-train.zsh", use:bullet-train.zsh-theme, as:theme, defer:3 # defer until other plugins like oh-my-zsh is loaded

# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history関係
#zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
#zplug "chrissicool/zsh-256color"

# zでフォルダ移動
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
alias open='xdg-open'
 
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
# wslかどうか
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    echo "in wsl"
    #genie(systemdをwslで使用できるようにする)を起動するかどうか
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


export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

export ANDROID_HOME=$HOME/Android/SDK
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export FLUTTER_ROOT=$HOME/Flutter/SDK
export PATH=$PATH:$FLUTTER_ROOT/bin
