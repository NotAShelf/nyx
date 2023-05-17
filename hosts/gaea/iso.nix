{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = lib.mkImageMediaOverride "gaea";

  isoImage = {
    isoName =
      lib.mkImageMediaOverride
      "gaea-${config.system.nixos.release}-${self.shortRev or "dirty"}-${pkgs.stdenv.hostPlatform.uname.processor}.iso";
    volumeID = "gaea-${config.system.nixos.release}-${self.shortRev or "dirty"}-${pkgs.stdenv.hostPlatform.uname.processor}";

    # faster compression in exchange for larger iso size
    squashfsCompression = "gzip -Xcompression-level 1";
  };
}
