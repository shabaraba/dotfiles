ABBR_SET_EXPANSION_CURSOR=1
rm ${ABBR_USER_ABBREVIATIONS_FILE}

# abbr import-aliases
# abbr import-git-aliases


abbr g='git'
abbr gs='git status'
abbr gb='git branch'
abbr gx='git branch --all | peco | sed -e "s/remotes\/origin\///g" | xargs git checkout'
abbr 'git branch x'='git branch --all | peco | sed -e "s/remotes\/origin\///g" | xargs git checkout'
abbr 'git branch clear'='git branch | grep -v "main\|develop" | xargs git branch -D'
abbr gc='git checkout'
abbr gcmt='git commit'
abbr gg='git grep'
abbr ga='git add'
abbr gd='git diff'
abbr gl='git show-branch | grep -E "\*\s*\[" -A 1 | tail -1 | awk -F'\''[]~^[]'\'' '\''{print $2}'\'' | xargs -Iparent git log parent..'
abbr gla='git log --graph --all --decorate'
abbr gf='git fetch --all'
abbr gpul='git pull'
abbr "git pull r"='git pull --rebase'
abbr gpsh='git push'
abbr "git push f"='git push --force-with-lease'
abbr gst='git stash'
abbr gsl='git stash list'
abbr gsu='git stash -u'
abbr gsp='git stash pop'
abbr gprune='git prune'

abbr d='docker'
abbr -f dc='docker compose'
abbr -f 'docker compose u'='docker compose up % -d'
abbr -f 'docker compose d'='docker compose down'
abbr de="docker exec -it % bash"
abbr dp='docker ps'
