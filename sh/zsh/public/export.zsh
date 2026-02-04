export LANGUAGE=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

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
  /usr/local/opt(N-/)
  /Library/Apple/usr/bin
)

if [ "$(uname)" = 'Linux' ]; then
    export PATH='/home/linuxbrew/.linuxbrew/bin':$PATH
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
export PATH="/usr/local/bin/node:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/mysql-client@5.7/bin:$PATH"

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# Java - macOS only
if [ "$(uname)" = "Darwin" ] && command -v /usr/libexec/java_home >/dev/null 2>&1; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 17)
    export PATH=$JAVA_HOME/bin:$PATH
fi

# Android設定は ~/.zshrc で行う

# export FLUTTER_ROOT=$HOME/Flutter/Sdk
# export PATH=$FLUTTER_ROOT/bin:$PATH
export PATH=$HOME/development/flutter/bin:$PATH

# phpenv
# export PATH="$HOME/.phpenv/bin:$PATH"
# eval "$(phpenv init -)"
# export PATH="$HOME/.phpenv/bin:$PATH"
# eval "$(phpenv init -)"

# rust - only if cargo exists
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# ruby
if [ "$(uname)" = "Darwin" ]; then
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi
# rbenv - only if installed
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

export PATH="$PATH:$HOME/go/bin"

# docker compose for better performance
export COMPOSE_BAKE=true

export PATH="$HOME/.local/nvim/bin:$HOME/.local/bin:$PATH"

# nvmを無効化（miseに一本化）
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# mise - polyglot runtime manager
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

export XDG_CONFIG_HOME="$HOME/.config"

# X11 DISPLAY設定（ローカルログイン時のみ）
if [ -z "$DISPLAY" ] && [ -z "$SSH_TTY" ]; then
    # ローカルログイン時のみDISPLAYを設定
    export DISPLAY=:0
fi

export PATH="$HOME/.cargo/bin:$PATH"
