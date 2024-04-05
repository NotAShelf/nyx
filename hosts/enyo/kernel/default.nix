{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) hostname;
  inherit (pkgs.callPackage ./package.nix {inherit hostname;}) xanmod_custom;
in {
  imports = [./config];
  config = {
    modules.system.boot.kernel = pkgs.linuxPackagesFor xanmod_custom;
  };
}
