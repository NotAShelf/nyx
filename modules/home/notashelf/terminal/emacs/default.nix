{pkgs, ...}: let
  doom-emacs =
    pkgs.callPackage (builtins.fetchTarball {
      url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
      sha256 = "0asprprdhh9d5cm0nyqyqlj47az4snm5fwc7pb4mcxwwybdqr3iq";
    }) {
      doomPrivateDir = ./doom.d;
    };
in {
  home.packages = [doom-emacs];
  services.emacs = {
    enable = true;
  };
}
