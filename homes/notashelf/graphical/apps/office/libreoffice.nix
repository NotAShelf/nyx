{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  dev = osConfig.modules.device;
  prg = osConfig.modules.programs;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && prg.libreoffice.enable) {
    home.packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.uk_UA
      hunspellDicts.en_US-large
      hunspellDicts.en_GB-large
    ];
  };
}
