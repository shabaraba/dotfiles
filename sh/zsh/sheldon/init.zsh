if ! command -v sheldon &> /dev/null; then
    brew install sheldon
fi

eval "$(sheldon source)"

# zsh-users/zsh-completions
autoload -Uz compinit
compinit -i

# zstyle ':autocomplete:*' default-context history-incremental-search-backward
# zstyle ':autocomplete:*' default-context history-incremental-search-backward
# '': Start each new command line with normal autocompletion.
# history-incremental-search-backward: Start in live history search mode.

# zstyle ':autocomplete:*' min-input 1  # int
# Wait until this many characters have been typed, before showing completions.

# bindkey '\0' list-expand
