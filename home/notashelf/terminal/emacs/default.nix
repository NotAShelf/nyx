{pkgs, ...}: let
  doom-emacs =
    pkgs.callPackage (builtins.fetchTarball {
      url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
      sha256 = "18c4q728y59mk83mx2i4vn7kppgcd4azxrq84r8z48684byaraq7";
    }) {
      doomPrivateDir = ./doom.d;
    };
in {
  home.packages = [doom-emacs];
  services.emacs = {
    enable = true;
  };
}
