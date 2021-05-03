export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# zplugの読み込み・初期化
source ~/.zplug/init.zsh

########################
# zplug setting
########################
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# theme (https://github.com/sindresorhus/pure#zplug)　好みのスキーマをいれてくだされ。
#zplug "mafredri/zsh-async"
#zplug "sindresorhus/pure"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history関係
#zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
#zplug "chrissicool/zsh-256color"

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

# load settings
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
alias v='vim'
alias vi='vim'
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
alias gcma='git checkout master'
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
if [ "`ps -eo pid,cmd | grep systemd | grep -v grep | sort -n -k 1 | awk 'NR==1 { print $1 }'`" != "1" ]; then
  genie -s
fi
