{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./direnv.nix
    ./nano.nix
  ];

  programs = {
    bash = {
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

    # less pager
    less.enable = true;

    # home-manager is quirky as ever, and wants this to be set in system config
    # instead of just home-manager
    zsh.enable = true;

    # run commands without installing the programs
    comma.enable = true;

    # type "fuck" to fix the last command that made you go "fuck"
    thefuck.enable = true;
  };
}
