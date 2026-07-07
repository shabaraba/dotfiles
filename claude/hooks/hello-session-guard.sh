#!/bin/bash
# Blocks GitHub push operations during an active hello session.
# hello skill creates /tmp/claude_hello_session; this hook checks for it.

FLAG="/tmp/claude_hello_session"

[ ! -f "$FLAG" ] && exit 0

# Expire after 24 hours in case cleanup was skipped
if find "$FLAG" -mmin +1440 -print 2>/dev/null | grep -q .; then
  rm -f "$FLAG"
  exit 0
fi

CMD=$(python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('command',''))" 2>/dev/null || echo "")

# Block: git push to any remote that isn't explicitly 'gitea'
if echo "$CMD" | grep -q "git push" && ! echo "$CMD" | grep -q "git push gitea"; then
  echo "[hello session] GitHub への push は禁じられています。" >&2
  echo "  Gitea への push のみ許可: git push gitea <branch>" >&2
  exit 2
fi

# Block: gh CLI write operations
if echo "$CMD" | grep -qE '\bgh\b.*(pr create|pr merge|release create|push)'; then
  echo "[hello session] GitHub への PR/push 操作は禁じられています。" >&2
  exit 2
fi

exit 0
