# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Homebrewのパス設定 (必要な場合のみ)
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
# fpath設定
fpath=(~/.zcompdump $fpath)

# ヒストリー設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# カラー設定
autoload -Uz colors
colors

# 必要な環境変数や基本設定を先に読み込む
[[ -f "$HOME/.zsh/public/export.zsh" ]] && source ~/.zsh/public/export.zsh
[[ -f "$HOME/.zsh/private/env.zsh" ]] && source ~/.zsh/private/env.zsh
[[ -f "$HOME/.zsh/public/setopt.zsh" ]] && source ~/.zsh/public/setopt.zsh

# 補完の初期化を最適化
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select

# プラグインの読み込み
source "$HOME/.zsh/sheldon/init.zsh"

# abbreviationsの重複を避けるためにここではロードしない
# [[ -f "$HOME/.zsh/contexts/abbreviations.zsh" ]] && source ~/.zsh/contexts/abbreviations.zsh

# エイリアスなどの設定を読み込む
[[ -f "$HOME/.zsh/public/alias.zsh" ]] && source ~/.zsh/public/alias.zsh
[[ -f "$HOME/.zsh/private/alias.zsh" ]] && source ~/.zsh/private/alias.zsh
[[ -f "$HOME/.zsh/public/abbr.zsh" ]] && source ~/.zsh/public/abbr.zsh
[[ -f "$HOME/.zsh/private/abbr.zsh" ]] && source ~/.zsh/private/abbr.zsh
[[ -f "$HOME/.zsh/contexts/git.zsh" ]] && source ~/.zsh/contexts/git.zsh
[[ -f "$HOME/.zsh/contexts/docker.zsh" ]] && source ~/.zsh/contexts/docker.zsh

# if (which zprof > /dev/null 2>&1) ;then
#   zprof
# fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$PATH:$HOME/development/flutter/bin"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ANDROID_HOME=/Users/t002451/Android/Sdk
unset ANDROID_SDK_ROOT
