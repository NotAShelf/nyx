# Configure menu selection for completion options in all contexts
# (indicated by the wildcard `*`)
zstyle ':completion:*' menu select

# forces zsh to realize new commands
# might be useful if new commands have been installed during the session
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# Group matches and describe.
zstyle ':completion:*' sort false
zstyle ':completion:complete:*:options' sort false


# rehash if command not found
# (possibly recently installed)
zstyle ':completion:*' rehash true

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
zstyle ':completion:*:expand:*' tag-order all-expansions

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''

zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:options' auto-description '%d'

# describe options in full
zstyle ':completion:*:options' description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -a -u $USER'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections   true
zstyle ':completion:*:man:*' menu yes select

# provide .. as a completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' special-dirs ..

# Use caching so that some commands commands (such as apt and dpkg complete)
# are useable
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# Don't try to expand multiple partial paths.
zstyle ':completion:*' path-completion false
