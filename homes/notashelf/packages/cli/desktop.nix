{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && osConfig.modules.programs.cli.enable) {
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
