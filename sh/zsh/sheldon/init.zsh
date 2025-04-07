if ! command -v sheldon &> /dev/null; then
    brew install sheldon
fi

eval "$(sheldon source)"

# 補完の初期化を最適化
# zsh-users/zsh-completions
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
