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
    ];

    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;

    stdlib = ''
      # https://github.com/direnv/direnv/wiki/Customizing-cache-location
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
          )}"
      }
    '';
  };
}
