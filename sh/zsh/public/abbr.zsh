dir=$(cd $(dirname $0); pwd)
abbrpath="../contexts/abbreviations.zsh"
export ABBR_USER_ABBREVIATIONS_FILE=$dir/$abbrpath

ABBR_SET_EXPANSION_CURSOR=1
ABBR_SET_LINE_CURSOR=1

ABBR_DEBUG=1
bindkey "^E" abbr-expand-and-insert
# ABBR_DEFAULT_BINDINGS=0
# bindkey " " abbr-expand
# abbr load
