# zsh-abbrの設定（存在する場合のみ）
if command -v abbr >/dev/null 2>&1; then
    dir=$(cd $(dirname $0); pwd)
    abbrpath="../contexts/abbreviations.zsh"
    export ABBR_USER_ABBREVIATIONS_FILE=$dir/$abbrpath

    ABBR_SET_EXPANSION_CURSOR=1
    ABBR_SET_LINE_CURSOR=1

    ABBR_DEBUG=0
    bindkey "^E" abbr-expand-and-insert
    # ABBR_DEFAULT_BINDINGS=0
    # bindkey " " abbr-expand
    
    # 権限エラーを回避するためディレクトリ作成
    mkdir -p /tmp/zsh-abbr
    chmod 755 /tmp/zsh-abbr 2>/dev/null || true
    
    abbr load 2>/dev/null || echo "Warning: abbr load failed, continuing..."
fi
