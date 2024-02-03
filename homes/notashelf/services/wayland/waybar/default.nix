{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.modules) device;
  inherit (osConfig.modules.style.colorScheme) slug colors;

  waybar_config = import ./presets/${slug}/config.nix {inherit osConfig config lib pkgs;};
  waybar_style = import ./presets/${slug}/style.nix {inherit colors;};

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs.python3Packages; [requests];
    programs.waybar = {
      enable = false;
      systemd.enable = true;
      package = pkgs.waybar;
      settings = waybar_config;
      style = waybar_style;
    };
  };
}
