{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = (buildins.elem device.type acceptedTypes) {
    home.packages = [
      pkgs.wezterm
    ];
    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
