abbr "d"="docker"
abbr "dc"="docker compose"
abbr "dcd"="docker compose down"
abbr "dcu"="docker compose up % -d"
abbr "de"="docker exec -it %bash"
abbr "docker compose d"="docker compose down"
abbr "docker compose u"="docker compose up %-d"
abbr "docker compose pu"="docker compose --profile % up -d"
abbr "docker compose pd"="docker compose --profile % down"
abbr "dp"="docker ps"
abbr "g"="git"
abbr "ga"="git add"
abbr "gb"="git branch"
abbr "gc"="git checkout"
abbr "gcmt"="git commit"
abbr "gd"="git diff"
abbr "gf"="git fetch --all"
abbr "gg"="git grep"
abbr "git branch clear"="git branch | grep -v \"main\|develop\" | xargs git branch -D"
abbr "git branch x"="git branch --all | peco | sed -e \"s/remotes\/origin\///g\" | xargs git checkout"
abbr "gx"="git branch --all | peco | sed -e \"s/remotes\/origin\///g\" | xargs git checkout"
abbr "git pull r"="git pull --rebase"
abbr "git push f"="git push --force-with-lease"
abbr "gl"="git show-branch | grep -E \"\*\s*\[\" -A 1 | tail -1 | awk -F'[]~^[]' '{print \$2}' | xargs -Iparent git log parent.."
abbr "gla"="git log --graph --all --decorate"
abbr "gprune"="git prune"
abbr "gpsh"="git push"
abbr "gpul"="git pull"
abbr "gs"="git status"
abbr "gsl"="git stash list"
abbr "gsp"="git stash pop"
abbr "gst"="git stash"
abbr "gsu"="git stash -u"

abbr "poff"="http_proxy= https_proxy="
