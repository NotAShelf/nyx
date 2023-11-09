{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = lib.mkImageMediaOverride "gaea";

  isoImage = let
    rev = self.shortRev or "dirty";
  in {
    # gaea-$rev-$arch.iso
    isoName = lib.mkImageMediaOverride "gaea-${config.system.nixos.release}-${rev}-${pkgs.stdenv.hostPlatform.uname.processor}.iso";
    # gaea-$release-$rev-$arch
    volumeID = "gaea-${config.system.nixos.release}-${rev}-${pkgs.stdenv.hostPlatform.uname.processor}";

    # faster compression in exchange for larger iso size
    squashfsCompression = "gzip -Xcompression-level 1";

    # hopefully makes the ISO bootable over ventoy
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
}
