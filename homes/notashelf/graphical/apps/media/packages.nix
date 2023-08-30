{
  pkgs,
  lib,
  osConfig,
  self',
  ...
}:
with lib; let
  inherit (osConfig.modules) device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      ffmpeg-full
      yt-dlp
      mpc_cli
      playerctl
      pavucontrol
      pulsemixer
      imv
      cantata
      easytag
      kid3

      # get ani-cli and mov-cli from my own derivations
      # I don't want to wait for nixpkgs
      self'.packages.mov-cli
      self'.packages.ani-cli
    ];
  };
}
