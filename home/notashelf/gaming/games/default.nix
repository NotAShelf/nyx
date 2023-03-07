{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
  device = osConfig.modules.device;

  acceptedTypes = ["laptop" "desktop" "lite"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (programs.gaming.enable)) {
    home.packages = with pkgs; [
      #gamescope # FIXME: override package wlroots
      legendary-gl
      prismlauncher
      mono
      winetricks
      mangohud
      taisei
      unciv
      # get dotnet runtime 6
      dotnet-runtime_6

      # jre 17
      temurin-jre-bin-17
    ];
  };

  # TODO: configure mangohud
}
