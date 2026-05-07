#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Run Zsh Command
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon >_
# @raycast.argument1 { "type": "text", "placeholder": "command" }

source ~/.zshenv 2>/dev/null
source ~/.zprofile 2>/dev/null
source ~/.zshrc 2>/dev/null

eval "$1"
