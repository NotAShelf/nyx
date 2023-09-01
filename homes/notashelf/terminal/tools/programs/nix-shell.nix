{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      alejandra
      deadnix
      statix
      nix-tree
      perl # for shasum
    ];

    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv = {
      enable = true;
    };

    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | shasum | cut -d ' ' -f 1
          )}"
      }
    '';
  };
}
