{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  override = osConfig.modules.programs.override;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!override.libreoffice)) {
    home.packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.uk_UA
      hunspellDicts.en_US-large
      hunspellDicts.en_GB-large
    ];
  };
}
