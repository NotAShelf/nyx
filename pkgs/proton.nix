{
  lib,
  pkgs,
  ...
}: let
  version = "7-41"; 
  source = fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/GE-Proton${version}.tar.gz";
    sha256 = "18hfag1nzj6ldy0ign2yjfzfms0w23vmcykgl8h1dfk0xjaql8gk";
  };
in {
  home.file.proton-ge-custom = rec {
    inherit source;
    recursive = true;
    target = ".steam/root/compatibilitytools.d/GE-Proton${version}/";
    onChange = "mkdir ${target}/files/share/default_pfx/dosdevices || true";
  };
}
