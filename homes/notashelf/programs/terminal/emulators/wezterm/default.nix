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
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs.wezterm = {
      enable = true;
      package = pkgs.wezterm;
      extraConfig = (import ./config.nix {inherit (config.colorscheme) colors;}).config;
    };
  };
}
