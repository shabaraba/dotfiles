# setopt NO_NOTIFY
# setopt NO_MONITOR
#
# すべてのコマンドをラップするためのpreexecフック
ai_command_wrapper() {
  echo "AI WRAPPER---start---"
  # 実行されるコマンドを取得
  local orig_command="$1"
  
  # スペースで区切って配列に変換
  local cmd_array=($orig_command)
  local main_cmd="${cmd_array[0]}"
  
  # 安全なコマンドリストにあるか確認
  # for safe_cmd in "${AI_SAFE_COMMANDS[@]}"; do
  #   if [[ "$main_cmd" == "$safe_cmd" ]]; then
  #     # 安全なコマンドはそのまま実行
  #     return
  #   fi
  # done

  # タイムアウト値を取得
  local timeout=${AI_CMD_TIMEOUTS[$main_cmd]:-$AI_DEFAULT_TIMEOUT}
  
  echo "AI WRAPPER---command: '$orig_command' ---"
  # コマンドをラップして実行
  ai_safe_exec "$orig_command" $timeout
  
  echo "AI WRAPPER---end---"
  # 元のコマンド実行を中断
  return 1
}

# コマンド別のタイムアウト設定
declare -A AI_CMD_TIMEOUTS=(
  ["git"]="15"     # gitコマンドは15秒
  ["find"]="20"    # findコマンドは20秒
  ["curl"]="20"    # curlコマンドは20秒
  ["npm"]="30"     # npmコマンドは60秒
  ["pip"]="30"     # pipコマンドは30秒
)

# デフォルトのタイムアウト値（秒）
AI_DEFAULT_TIMEOUT=1

# preexecフックを設定
autoload -Uz add-zsh-hook
add-zsh-hook preexec ai_command_wrapper

# エラーに強いコマンド実行関数
ai_safe_exec() {
    echo "hello AI in ai-safe-exec"
  local cmd="$1"
  # local timeout_sec="${2:-10}s"
  local timeout_sec="1s"
  
  local stdout
  local stderr
  stdout=$(mktemp)
  stderr=$(mktemp)
  trap 'rm -f "$stdout" "$stderr"' EXIT

  # 実行
  gtimeout "$timeout_sec" bash -c "$cmd" >"$stdout" 2>"$stderr"
  local exit_code=$?

  local out err
  out=$(<"$stdout")
  err=$(<"$stderr")

  echo "$out"
  # 元のコマンドの stderr もそのまま出力
  if [[ -n "$err" ]]; then
    echo "$err" >&2  # stderrに出力
  fi

  if [[ $exit_code -ne 0 || -n "$err" ]]; then
    echo "【AIデバッグ情報】コマンド '$cmd' の実行中にエラーが発生しました"
    echo "【エラー内容】 $err"
    echo "【終了コード】 $exit_code"
  fi

  return 0
}

# コマンド別のタイムアウト設定
declare -A AI_CMD_TIMEOUTS=(
  ["git"]="15"     # gitコマンドは15秒
  ["find"]="20"    # findコマンドは20秒
  ["grep"]="15"    # grepコマンドは15秒
  ["curl"]="20"    # curlコマンドは20秒
  ["wget"]="20"    # wgetコマンドは20秒
  ["npm"]="60"     # npmコマンドは60秒
  ["yarn"]="60"    # yarnコマンドは60秒
  ["pip"]="30"     # pipコマンドは30秒
  ["brew"]="60"    # brewコマンドは60秒
  ["apt"]="60"     # aptコマンドは60秒
  ["yum"]="60"     # yumコマンドは60秒
)

# デフォルトのタイムアウト値（秒）
AI_DEFAULT_TIMEOUT=10

