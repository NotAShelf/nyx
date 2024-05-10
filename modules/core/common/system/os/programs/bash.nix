{
  pkgs,
  lib,
  ...
}: {
  programs.bash = {
    # when entering the interactive shell, set the history file to
    # the config directory to avoid cluttering the $HOME directory
    interactiveShellInit = ''
      export HISTFILE="$XDG_STATE_HOME"/bash_history
    '';

    # initialize starship in impromptu bash sessions
    # (e.g. when running a command without entering a shell)
    promptInit = ''
      eval "$(${lib.getExe pkgs.starship} init bash)"
    '';
  };
}
