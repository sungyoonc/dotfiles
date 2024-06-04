prompt_git_status() {
    ref="$(git symbolic-ref --short HEAD 2>/dev/null)"
    if [ $? -ne 0 ] || [[ "$(git config --get oh-my-zsh.hide-info 2>/dev/null)" == "1" ]]; then
        return 0
    fi

    dirty=$(git -C "$1" status --porcelain --ignore-submodules -unormal 2>/dev/null | wc -l)
    if [ $dirty -ne 0 ]; then
        local dirty_prompt=$ZSH_THEME_GIT_PROMPT_DIRTY
    else
        local dirty_prompt=$ZSH_THEME_GIT_PROMPT_CLEAN
    fi
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${dirty_prompt}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"

PROMPT+=' $(prompt_git_status)'
PROMPT+='%(!.#.$) ' # $ for user # for root

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}%1{%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
