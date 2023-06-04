{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}:
with lib; let
  slug = osConfig.profiles.style.colorScheme.slug;

  waybar_config = import ./styles/${slug}/config.nix {inherit osConfig config lib pkgs;};
  waybar_style = import ./styles/${slug}/style.nix {inherit (config) colorscheme;};
  device = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      python39Packages.requests
    ];
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
      settings = waybar_config;
      style = waybar_style;
    };
  };
}
