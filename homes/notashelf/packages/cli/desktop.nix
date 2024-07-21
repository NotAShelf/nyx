{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) isAcceptedDevice;
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  pkg = env.packages;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((isAcceptedDevice osConfig acceptedTypes) && pkg.cli.enable) {
    home.packages = with pkgs; [
      # CLI
      libnotify
      imagemagick
      bitwarden-cli
      trash-cli
      slides
      brightnessctl
      pamixer
      nix-tree
    ];
  };
}
