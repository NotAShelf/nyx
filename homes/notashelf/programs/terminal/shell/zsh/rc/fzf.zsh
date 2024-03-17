autoload -U add-zle-hook-widget

# autosuggests otherwise breaks these widgets.
# <https://github.com/zsh-users/zsh-autosuggestions/issues/619>
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-beginning-search-backward-end history-beginning-search-forward-end)

# FZF widgets
function __fzf() {
	if [[ -n "$TMUX_PANE" && ( "${FZF_TMUX:-0}" != 0 || -n "$FZF_TMUX_OPTS" ) ]]; then
		fzf-tmux -d"${FZF_TMUX_HEIGHT:-40%}" -- "$@"
	else
		fzf "$@"
	fi
}

function __fzf_select() {
	setopt localoptions pipefail no_aliases 2>/dev/null
	local item
	FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore,tab:down,btab:up,change:top,ctrl-space:toggle $FZF_DEFAULT_OPTS" __fzf "$@" | while read item; do
		echo -n "${(q)item} "
	done
	local ret=$?
	echo
	return $ret
}

function __fzf_find_files() {
	local include_hidden=${1:-0}
	local types=${2:-fdl}
	shift 2
	local type_selectors=()
	local i
	for (( i=0; i<${#types}; i++ )); do
		[[ "$i" -gt 0 ]] && type_selectors+=('-o')
		type_selectors+=('-type' "${types:$i:1}")
	done
	local hide_hidden_files=()
	if [[ $include_hidden == "0" ]]; then
		hide_hidden_files=('-path' '*/\.*' '-o')
	fi
	setopt localoptions pipefail no_aliases 2>/dev/null
	command find -L . -mindepth 1 \
			\( "${hide_hidden_files[@]}" -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \) -prune \
			-o \( "${type_selectors[@]}" \) -print \
		| __fzf_select "$@"
}

function __fzf_find_files_widget_helper() {
	LBUFFER="${LBUFFER}$(__fzf_find_files "$@")"
	local ret=$?
	zle reset-prompt
	return $ret
}

function fzf-select-file-or-dir()        { __fzf_find_files_widget_helper 0 fdl -m; }; zle -N fzf-select-file-or-dir
function fzf-select-file-or-dir-hidden() { __fzf_find_files_widget_helper 1 fdl -m; }; zle -N fzf-select-file-or-dir-hidden
function fzf-select-dir()                { __fzf_find_files_widget_helper 0 d -m; };   zle -N fzf-select-dir
function fzf-select-dir-hidden()         { __fzf_find_files_widget_helper 1 d -m; };   zle -N fzf-select-dir-hidden
function fzf-cd() {
	local dir="$(__fzf_find_files 0 d +m)"
	if [[ -z "$dir" ]]; then
		zle redisplay
		return 0
	fi
	zle push-line # Clear buffer. Auto-restored on next prompt.
	BUFFER="cd -- $dir"
	zle accept-line
	local ret=$?
	unset dir # ensure this doesn't end up appearing in prompt expansion
	zle reset-prompt
	return $ret
}
zle -N fzf-cd
