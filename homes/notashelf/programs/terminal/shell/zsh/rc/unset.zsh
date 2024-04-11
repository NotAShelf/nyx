# Define a function to unset Zsh options
function __unset_zsh_options() {
  local options=(
    "CORRECT_ALL"   # try to correct the spelling of all arguments in a line.
    "HIST_BEEP"     # beep in ZLE when a widget attempts to access a history entry which isn’t there
	"SHARE_HISTORY" # read the documentation for more details (too long)
  )

  for option in "${options[@]}"; do
    unsetopt $option
  done
}

__unset_zsh_options
