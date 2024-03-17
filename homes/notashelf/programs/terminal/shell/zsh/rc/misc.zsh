# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|kitty*)
		TERM_TITLE=$'\e]0;%n@%m: %1~\a'
        ;;
    *)
        ;;
esac

# enable keyword-style arguments in shell functions
set -k

# Colors
autoload -Uz colors && colors

# Autosuggest
ZSH_AUTOSUGGEST_USE_ASYNC="true"

# open commands in $EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line
