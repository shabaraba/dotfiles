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

alias c='clear'
alias ls='ls -GF --color'
alias his='history'
alias ...='cd ../..'
alias ....='cd ../../..'
alias v='nvim'
 
alias g='git'
alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gx='git branch --all | peco | sed -e "s/remotes\/origin\///g" | xargs git checkout'
alias gcmt='git commit'
alias gg='git grep'
alias ga='git add'
alias gd='git diff'
alias gl='git show-branch | grep -E "\*\s*\[" -A 1 | tail -1 | awk -F'\''[]~^[]'\'' '\''{print $2}'\'' | xargs -Iparent git log parent..'
alias gla='git log --graph --all --decorate'
alias gf='git fetch --all'
alias gpul='git pull'
alias gpsh='git push'
alias gst='git stash'
alias gsl='git stash list'
alias gsu='git stash -u'
alias gsp='git stash pop'
alias gclear='git branch | grep -v "main\|develop" | xargs git branch -D'
alias gprune='git prune'

alias dc='docker compose'
alias dp='docker ps'

# android device bridgh
# wsl2ではusb接続されたデバイスを認識できず、実機デバッグしにくいので、
# windowsのadbを使用する（rootにadbという名前でwindowsのadb.exeにシンボリックリンクを張っている）
# alias adb='~/adb'
alias adb='/mnt/d/tools/platform-tools/adb.exe'
alias flutter='/mnt/c/flutter/bin/flutter'
alias dart='/mnt/c/flutter/bin/dart'
