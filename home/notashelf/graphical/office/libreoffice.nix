{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  override = osConfig.modules.programs.override.program;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (!override.libreoffice)) {
    home.packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.uk_UA
    ];
  };
}
