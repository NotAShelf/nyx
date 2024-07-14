{
  pkgs,
  lib,
  ...
}: {
  programs.bash = {
    # When entering the interactive shell, set the history file to
    # the config directory to avoid cluttering the $HOME directory
    interactiveShellInit = ''
      export HISTFILE="$XDG_STATE_HOME"/bash_history
    '';

    # Initialize Starship prompt in impromptu (pun intended) bash
    # sessions initialized by, e.g., running a command without
    # entering a shell. This will also cause Starship to be the
    # default shell for the root user.
    promptInit = ''
      eval "$(${lib.getExe pkgs.starship} init bash)"
    '';
  };
}
