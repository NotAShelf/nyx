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

    # this needs to be enabled globally to be able to use zsh as a login shell
    zsh.enable = true;
  };
}
