{
  pkgs,
  inputs,
  ...
}: {
  home = {
    packages = with pkgs; [
      alejandra
      deadnix
      nix-index
      statix
      perl # for shasum
    ];

    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  programs.direnv = {
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
    enableZshIntegration = true;

    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
