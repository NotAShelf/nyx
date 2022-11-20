{pkgs, ...}: let
  doom-emacs =
    pkgs.callPackage (builtins.fetchTarball {
      url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
      sha256 = "16l0kpahklch9qq21k00ipq85q5nxw3na0kflcybfdsxr9i3z95a";
    }) {
      doomPrivateDir = ./doom.d;
    };
in {
  home.packages = [doom-emacs];

  services.emacs = {
    enable = true;
  };
}
