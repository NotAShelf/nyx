{
  pkgs,
  lib,
  osConfig,
  inputs',
  ...
}: let
  dev = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = lib.mkIf (builtins.elem dev.type acceptedTypes) {
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
      inputs'.nyxpkgs.packages.mov-cli
      inputs'.nyxpkgs.packages.ani-cli
    ];
  };
}
