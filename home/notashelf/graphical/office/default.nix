{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.uk_UA
    ];
  };
}
