{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkImageMediaOverride;
in {
  # A stripped-down version of ISO role
  system.switch.enable = false;

  isoImage = let
    hostname = config.networking.hostName or "nixos";
    rev = self.shortRev or "${builtins.substring 0 8 self.lastModifiedDate}-dirty";
    # $hostname-$release-$rev-$arch
    name = "${hostname}-${config.system.nixos.release}-${rev}-${pkgs.stdenv.hostPlatform.uname.processor}";
  in {
    isoName = mkImageMediaOverride "${name}.iso";
    volumeID = mkImageMediaOverride "${name}";
    squashfsCompression = "zstd -Xcompression-level 10"; # default uses gzip
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
}
