{pkgs, ...}: let
  doom-emacs =
    pkgs.callPackage (builtins.fetchTarball {
      url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
      sha256 = "0a1rpjzy3zf0v6zqwpm744mhfr03fsz5ndgkm12cfi16wi77ycc1";
    }) {
      doomPrivateDir = ./doom.d;
    };
in {
  home.packages = [doom-emacs];
  services.emacs = {
    enable = true;
  };
}
