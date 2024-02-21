{
  pkgs,
  lib,
  ...
}: {
  services.logrotate.settings.header = {
    compress = true; # lets compress logs to save space
    compresscmd = "${lib.getExe' pkgs.zstd "zstd"}";
    compressoptions = " -Xcompression-level 10";
    compressext = "zst";
  };
}
