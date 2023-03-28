{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  isoImage.isoName =
    lib.mkImageMediaOverride
    "gaea-${config.system.nixos.release}-${self.shortRev or "dirty"}-${pkgs.stdenv.hostPlatform.uname.processor}.iso";
  isoImage.volumeID = "gaea-${config.system.nixos.release}-${self.shortRev or "dirty"}-${pkgs.stdenv.hostPlatform.uname.processor}";

  # faster compression in exchange for larger iso size
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  networking.hostName = lib.mkImageMediaOverride "gaea";
}
