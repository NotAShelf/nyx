{
  config,
  lib,
  pkgs,
  ...
}: {
  programs = {
    # starship prompt
    bash = {
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

    # enable direnv integration
    direnv = {
      enable = true;

      # shut up. SHUT UP
      silent = true;

      # faster, persistent implementation of use_nix and use_flake
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv.override {
          nix = config.nix.package;
        };
      };
    };
  };
}
