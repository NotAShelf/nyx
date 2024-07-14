{pkgs, ...}: {
  programs.direnv = {
    enable = true;

    # Shut up, direnv. SHUT. UP.
    silent = true;

    # Faster, persistent implementation of use_nix and use_flake in
    # direnv based shells.
    nix-direnv.enable = true;

    # Enable loading direnv in nix-shell, nix shell or nix develop
    loadInNixShell = true;

    # From upstream:
    # * `direnv_layour_dir` is called once for every {.direnvrc,.envrc} sourced
    # * The indicator for a different direnv file being sourced is a different $PWD value
    # This means we can hash $PWD to get a fully unique cache path for any given environment
    # See: <https://github.com/direnv/direnv/wiki/Customizing-cache-location>
    direnvrcExtra = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs

      direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
          echo -n "$XDG_CACHE_HOME"/direnv/layouts/
          echo -n "$PWD" | ${pkgs.perl}/bin/shasum | cut -d ' ' -f 1
        )}"
      }
    '';
  };
}
