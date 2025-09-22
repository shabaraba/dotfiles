if ! command -v sheldon &> /dev/null; then
    brew install sheldon
fi

eval "$(sheldon source)"

# 補完の初期化は.zshrcで一元管理（重複回避）
# zsh-users/zsh-completions
