# Load compinit
autoload -U compinit
zmodload zsh/complist

compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"-"$(date)"
_comp_options+=(globdots)

# Configure menu selection for completion options in all contexts
# (indicated by the wildcard `*`)
zstyle ':completion:*' menu select

# Group matches and describe.
zstyle ':completion:*' sort false
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' rehash true

# Sort completions
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# preview directory's content when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -lAhF --group-directories-first --show-control-chars --quoting-style=escape --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 20 0
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:eza' sort false
zstyle ':completion:files' sort false

# Job IDs
zstyle ':completion:*:jobs' numbers true
zstyle ':completion:*:jobs' verbose true

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# No correction
zstyle ':completion:*' completer _oldlist _expand _complete _files _ignored

# Don't insert tabs when there is no completion (e.g. beginning of line)
zstyle ':completion:*' insert-tab false

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*' original true

# List directory completions first
zstyle ':completion:*' list-dirs-first true
# Offer the original completion when using expanding / approximate completions
zstyle ':completion:*' original true
# Treat multiple slashes as a single / like UNIX does (instead of as /*/)
zstyle ':completion:*' squeeze-slashes true

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# provide .. as a completion
zstyle ':completion:*' special-dirs ..
