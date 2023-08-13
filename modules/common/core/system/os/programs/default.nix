{
  pkgs,
  lib,
  ...
}: {
  programs = {
    bash = {
      promptInit = ''
        eval "$(${lib.getExe pkgs.starship} init bash)"
      '';
    };
    # less pager
    # TODO: package moar for nix
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
