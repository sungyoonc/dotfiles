# ========================== #
#  zsh - .zshrc              #
#  Maintainter: sungyoonc    #
# ========================== #
#                            #
#                            #
#  ███████╗███████╗██╗  ██╗  #
#  ╚══███╔╝██╔════╝██║  ██║  #
#    ███╔╝ ███████╗███████║  #
#   ███╔╝  ╚════██║██╔══██║  #
#  ███████╗███████║██║  ██║  #
#  ╚══════╝╚══════╝╚═╝  ╚═╝  #
#                            #
#                            #
# ========================== #

# Lines configured by zsh-newuser-install
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/fox/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U colors && colors
# Expand variables and commands in PROMPT variables
setopt prompt_subst

# ---------------------- #
#  zinit plugin manager  #
# ---------------------- #
declare -A ZINIT
ZINIT[NO_ALIASES]=1

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load plugins
# - prompt
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::themes/robbyrussell.zsh-theme
PROMPT+='%(!.#.$) '
# - completion
zinit ice blockf
zinit light zsh-users/zsh-completions
# - suggestion
zinit ice wait lucid blockf atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
# - docker completion
zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
# - syntax highlighting
zinit ice wait lucid blockf
zinit light zdharma-continuum/fast-syntax-highlighting


# ------------- #
#  User config  #
# ------------- #

# Alias
alias ls='ls --color=auto'
alias ll='ls -lav --ignore=..'   # show long listing of all except ".."
alias l='ls -lav --ignore=".?*"'   # show long listing but no hidden dotfiles except "."
alias vim='nvim'
alias cargo-nogit='cargo new --vcs=none'

# Keybinds
# - Use `cat` command and type the key to find the key sequence
# - for more widgets visit https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
bindkey "^[[3~" delete-char         # Delete
bindkey "^[[1;5C" forward-word      # Ctrl + Left arrow
bindkey "^[[1;5D" backward-word     # Ctrl + Right arrow
bindkey "^H" backward-delete-word   # Ctrl + Backspace
bindkey "^[[3;5~" delete-word       # Ctrl + Delete


# -------------- #
#  ZSH function  #
# -------------- #

# Emulate bash way of fg, bg, history command
# - tip: for fg you can also just use "%1", "%-", etc.
fg() {
  if [[ $# -eq 1 && $1 = - ]]; then
    builtin fg %-
  else
    builtin fg %"$@"
  fi
}
bg() {
  if [[ $# -eq 1 && $1 = - ]]; then
    builtin bg %-
  else
    builtin bg %"$@"
  fi
}

# Set up GPG-AGENT
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
gpg-connect-agent updatestartuptty /bye > /dev/null # help pgp find user tty for password prompts
export GPG_TTY=$(tty)
