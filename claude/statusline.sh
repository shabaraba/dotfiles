#!/bin/bash
# Claude Codeのstatusline hook。モデル名はstdinのセッションJSONから、使用率は
# ~/.claude.json の cachedUsageUtilization から取る。
#
# stdinのrate_limitsはセッション初回API応答後にしか現れず起動直後は空になるが、
# cachedUsageUtilizationには前回の値が残っているため起動直後から表示できる。
# ただしこのフィールドが更新されるのは /usage が実行されたときだけなので、
# 鮮度はclaude-usage.wezterm側の定期リフレッシュ（毎分 claude -p "/usage"）に依存する。

MODEL=$(jq -r '.model.display_name // "?"')

read -r FIVE_H WEEK < <(
  jq -r '.cachedUsageUtilization.utilization
         | "\(.five_hour.utilization // "") \(.seven_day.utilization // "")"' \
     "$HOME/.claude.json" 2>/dev/null
)

if [[ -n "$FIVE_H" && -n "$WEEK" ]]; then
  printf '[%s] 5h %.0f%% / week %.0f%%\n' "$MODEL" "$FIVE_H" "$WEEK"
else
  printf '[%s]\n' "$MODEL"
fi
