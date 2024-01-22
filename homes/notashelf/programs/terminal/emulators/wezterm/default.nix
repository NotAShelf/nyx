{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    programs.wezterm = {
      enable = true;
      package = pkgs.wezterm;
      extraConfig = (import ./config.nix {inherit (config.colorscheme) colors;}).config;
    };
  };
}
