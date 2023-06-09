{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
  device = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (programs.cli.enable)) {
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
    ];
  };
}
