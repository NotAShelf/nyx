{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  inherit (modules.style.colorScheme) colors;

  dev = modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    programs.wezterm = {
      enable = true;
      package = pkgs.wezterm;
      extraConfig = import ./config.nix {inherit colors;};
    };
  };
}
