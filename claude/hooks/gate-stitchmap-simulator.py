#!/usr/bin/env python3
"""PreToolUse hook: cross-stitch-app でシミュレータを新しく作る操作に確認を挟む。

全 worktree で常設3台（iPhone 17 Pro Max・iPad Pro 13-inch (M5)・iPhone Duo）を
ロックで排他して使う。`simctl create` / `clone` と、実行のたびに一時端末を作る
E2E ランナーは、worktree ごとに端末を増やして負荷を上げるので都度承認にする。
"""

import json
import re
import sys

PROJECT = "/cross-stitch-app"
CREATES_DEVICE = re.compile(r"simctl\s+(create|clone)\b|test:e2e:ios|scripts/e2e-ios\.mjs")

REASON = (
    "cross-stitch-app ではシミュレータを新しく作りません（検出: `{match}`）。\n"
    "確認には常設3台を `/tmp/stitchmap-sim-<名前>.lock` で排他して使ってください。\n"
    "E2E ランナーは実行のたびに一時端末を作ります。続行する場合は、"
    "ほかの E2E・一時端末が無いことと、新しい端末が必要な理由をユーザーに伝えて承認を得てください。"
)


def command_text(tool_input):
    command = tool_input.get("command", "")
    return " ".join(command) if isinstance(command, list) else str(command)


def main():
    payload = json.load(sys.stdin)
    tool_input = payload.get("tool_input") or {}
    command = command_text(tool_input)
    locations = " ".join([payload.get("cwd", ""), str(tool_input.get("cwd", "")), command])
    match = CREATES_DEVICE.search(command)
    if PROJECT not in locations or not match:
        return
    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "ask",
                "permissionDecisionReason": REASON.format(match=match.group(0)),
            }
        },
        sys.stdout,
        ensure_ascii=False,
    )


if __name__ == "__main__":
    main()
