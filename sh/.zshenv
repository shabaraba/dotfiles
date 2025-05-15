# zmodload zsh/zprof && zprof
# 自分のプロセスの親プロセスIDを取得
parent_pid=$(ps -o ppid= -p $$)
# 親プロセスがVS Code関連かチェック
ps -p $parent_pid -o command= | grep -q "Code Helper.*node.mojom.NodeService"
if [ $? -eq 0 ]; then
  echo "VSCode Copilot Agent Modeのzshセッションです"
else
  echo "通常のzshセッションです"
fi

parent_cmd=$(ps -o comm= -p $(ps -o ppid= -p $$) 2>/dev/null)
if [[ "$parent_cmd" == *"Code Helper"* || "$VIA_CLAUDE_CODE" == "1" ]]; then
    [[ -f "$HOME/.zsh/public/aiwrapper.zsh" ]] && source ~/.zsh/public/aiwrapper.zsh
fi
. "$HOME/.cargo/env"
