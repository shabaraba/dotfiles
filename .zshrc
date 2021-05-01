export LANG=Ja_JP.UTF-8
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
