{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf isAcceptedDevice;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((isAcceptedDevice osConfig acceptedTypes) && osConfig.modules.usrEnv.programs.cli.enable) {
    home.packages = with pkgs; [
      # CLI
      libnotify
      imagemagick
      gcc
      cmake
      bitwarden-cli
      trash-cli
      python39Packages.requests
      slides
      brightnessctl
      tesseract5
      pamixer
      xorg.xhost
    ];
  };
}
