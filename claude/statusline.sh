#!/bin/bash
# Claude Codeのstatusline hook。stdinのセッションJSONからrate_limits(5h/週次の
# 正確な使用率とリセット時刻)を抜き出し、WezTermプラグインが読むキャッシュへ書き出す。
# rate_limitsはPro/Maxサブスクライバーのセッション初回API応答後にのみ出現するため、
# 存在しない場合はnullのまま書き出す(wezterm側で前回値を維持する想定)。

CACHE_FILE="/tmp/wezterm-claude-usage.json"

input=$(cat)

echo "$input" | jq -c '{
  five_hour: .rate_limits.five_hour,
  seven_day: .rate_limits.seven_day,
  updated_at: now
}' > "${CACHE_FILE}.tmp" 2>/dev/null && mv "${CACHE_FILE}.tmp" "$CACHE_FILE"

MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

if [[ -n "$FIVE_H" && -n "$WEEK" ]]; then
  printf '[%s] 5h %.0f%% / week %.0f%%\n' "$MODEL" "$FIVE_H" "$WEEK"
else
  printf '[%s]\n' "$MODEL"
fi
