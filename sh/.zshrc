# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# プロファイリング用（一時的）
# zmodload zsh/zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Homebrewのパス設定 (必要な場合のみ)
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
# fpath設定（補完関数のパスを追加）
# fpath=(~/.zsh/completions $fpath)  # 必要に応じてカスタム補完ディレクトリを追加

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

# プラグインの読み込み（補完初期化前）
source "$HOME/.zsh/sheldon/init.zsh"

# 補完の初期化を最適化
autoload -Uz compinit
# zcompdumpが24時間以上古い場合は再生成
if [[ ! -f ~/.zcompdump ]] || [[ ~/.zshrc -nt ~/.zcompdump ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select

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


# nvmを無効化（miseに一本化）
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Android development environment
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
unset ANDROID_SDK_ROOT

# mise
eval "$(mise activate zsh)"

# zoxide initialization
eval "$(/opt/homebrew/bin/zoxide init zsh)"
export PATH="$HOME/.local/bin:$PATH"

# Added by Antigravity
export PATH="/Users/shaba/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "/Users/shaba/.bun/_bun" ] && source "/Users/shaba/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
