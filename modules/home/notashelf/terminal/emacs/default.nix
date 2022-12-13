{pkgs, ...}: let
  doom-emacs =
    pkgs.callPackage (builtins.fetchTarball {
      url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
      sha256 = "1d3cbhzfxlkl2m6bxi6j5i4q50divmp8hjl213jb0gfhcxr28i6s";
    }) {
      doomPrivateDir = ./doom.d;
    };
in {
  home.packages = [doom-emacs];
  services.emacs = {
    enable = true;
  };
}
