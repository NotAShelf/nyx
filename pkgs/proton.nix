{
  lib,
  pkgs,
  ...
}: let
  version = "7-41";
  source = fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${version}/GE-Proton${version}.tar.gz";
    sha256 = "0mz4032pd3ky51h9q3fxm581naal241wjh9gnvkh72s1jgymka3y";
  };
in {
  home.file.proton = rec {
    inherit source;
    recursive = true;
    target = ".steam/root/compatibilitytools.d/GE-Proton${version}/";
    onChange = "mkdir ${target}/files/share/default_pfx/dosdevices || true";
  };
}
