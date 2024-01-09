{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.system.programs;
  dev = modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && prg.libreoffice.enable) {
    home.packages = with pkgs; [
      libreoffice-qt
      hyphen # text hyphenation library
      hunspell
      hunspellDicts.en_US-large
      hunspellDicts.en_GB-large
    ];
  };
}
