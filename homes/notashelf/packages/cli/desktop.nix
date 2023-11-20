{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  prg = osConfig.modules.programs;
  dev = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && prg.cli.enable) {
    home.packages = with pkgs; [
      # CLI
      libnotify
      imagemagick
      gcc
      cmake
      bitwarden-cli
      trash-cli
      slides
      brightnessctl
      tesseract5
      pamixer
    ];
  };
}
