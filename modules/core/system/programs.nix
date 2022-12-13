{pkgs, ...}: {
  programs = {
    bash.promptInit = ''
      eval "${pkgs.starship}/bin/starship init bash"
    '';
    less.enable = true;
  };
}
