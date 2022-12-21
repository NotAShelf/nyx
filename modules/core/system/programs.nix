{pkgs, ...}: {
  programs = {
    bash = {
      promptInit = ''
        eval "${pkgs.starship}/bin/starship init bash"
      '';
    };
    # less pager
    # TODO: package moar for nix
    less.enable = true;
  };
}
