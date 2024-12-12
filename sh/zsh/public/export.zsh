export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LESSCHARSET=utf-8

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

export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:/usr/local/opt/mysql-client@5.7/bin"

# nodenv
[[ -d ~/.nodenv  ]] && \
    export PATH="$HOME/.nodenv/bin:$PATH" && \
    eval "$(nodenv init -)"

# nvm
function load-nvm () {
  export NVM_DIR="$HOME/.nvm"
  [[ -s $(brew --prefix nvm)/nvm.sh ]] && source $(brew --prefix nvm)/nvm.sh
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
}
autoload -U add-zsh-hook
load-nvmrc() {

  if [[ -f .nvmrc && -r .nvmrc ]]; then
    if ! type nvm >/dev/null; then
      load-nvm
    fi
    nvm use
  fi
  # local node_version="$(nvm version)"
  # local nvmrc_path="$(nvm_find_nvmrc)"
  #
  # if [ -n "$nvmrc_path" ]; then
  #   local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
  #
  #   if [ "$nvmrc_node_version" = "N/A" ]; then
  #     nvm install
  #   elif [ "$nvmrc_node_version" != "$node_version" ]; then
  #     nvm use
  #   fi
  # elif [ "$node_version" != "$(nvm version default)" ]; then
  #   echo "Reverting to nvm default version"
  #   nvm use default
  # fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

export ANDROID_SDK_ROOT=$HOME/.android
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools:$PATH
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$PATH
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools/lib:$PATH
export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
export PATH=$ANDROID_SDK_ROOT/emulator:$PATH

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$PATH:$JAVA_HOME/bin

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# export FLUTTER_ROOT=$HOME/Flutter/Sdk
# export PATH=$FLUTTER_ROOT/bin:$PATH

# phpenv
# export PATH="$HOME/.phpenv/bin:$PATH"
# eval "$(phpenv init -)"
# export PATH="$HOME/.phpenv/bin:$PATH"
# eval "$(phpenv init -)"
#
