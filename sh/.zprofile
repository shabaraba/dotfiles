if[[$(uname)=="DArwin"]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
# eval $(/usr/bin/locale-check C.UTF-8)
