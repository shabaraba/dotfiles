PROMPT='%~ %# '

autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
autoload -Uz colors; colors

setopt prompt_subst
setopt re_match_pcre

function current-git-branch() {
    echo -n "$(git rev-parse --abbrev-ref=loose HEAD 2> /dev/null)"
}

function zle-line-init zle-line-finish
{
    p_cdr="%F{cyan}%~%f"
    p_vimjob="%F{green}$([[ $(jobs|grep -c vim) != 0 ]] && print "vim:$(jobs|grep -c vim) ")%f"
    p_branch="%F{magenta}$(current-git-branch)%f"
    p_user="%F{yellow}%n%f"
    p_mark="%B%(?,%F{green},%F{red})%(!,#,$)%f%b"
    PROMPT="(${p_user}) > {${p_cdr}}[${p_branch}]
${p_vimjob}${p_mark} "

    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish

# folder, link, and exe files color setting
export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'

PROMPT='%~ %# '

bindkey -d # reset keybind
bindkey -e # use emacs mode
# bindkey -v # use vim mode
# bindkey -M viins 'jj' vi-cmd-mode
 
# function zle-line-init zle-keymap-select {
#     VIM_NORMAL="%K{208}%F{black}%k%f%K{208}%F{white} % NORMAL %k%f%K{black}%F{208}%k%f"
#     VIM_INSERT="%K{075}%F{black}%k%f%K{075}%F{white} % INSERT %k%f%K{black}%F{075}%k%f"
#     RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
#     RPS2=$RPS1
#     zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select
