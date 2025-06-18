# zmodload zsh/zprof && zprof

parent_cmd=$(ps -o comm= -p $(ps -o ppid= -p $$) 2>/dev/null)
if [[ "$parent_cmd" == *"Code Helper"* || "$VIA_CLAUDE_CODE" == "1" ]]; then
    [[ -f "$HOME/.zsh/public/aiwrapper.zsh" ]] && source ~/.zsh/public/aiwrapper.zsh
fi
. "$HOME/.cargo/env"
