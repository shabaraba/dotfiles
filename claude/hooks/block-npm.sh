#!/bin/bash
# npm / npx の実行を拒否する(pnpm を使う)。PreToolUse(Bash) から呼ばれる。

CMD=$(python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

if echo "$CMD" | grep -qE '(^|[;&|(`[:space:]/])(npm|npx)([[:space:]]|$)'; then
  echo "npm / npx は使用禁止です。pnpm / pnpm exec / pnpm dlx を使ってください。" >&2
  exit 2
fi

exit 0
