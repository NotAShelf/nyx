{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  inherit (osConfig.modules.style.colorScheme) slug;

  waybar_config = import ./presets/${slug}/config.nix {inherit osConfig config lib pkgs;};
  waybar_style = import ./presets/${slug}/style.nix {inherit (config) colorscheme;};

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && (lib.isWayland osConfig)) {
    home.packages = with pkgs.python39Packages; [requests];
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      package = pkgs.waybar;
      settings = waybar_config;
      style = waybar_style;
    };
  };
}
