{
  inputs',
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;

  cfg = prg.media;
in {
  config = mkIf cfg.addDefaultPackages {
    home.packages = with pkgs;
      [
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
      ]
      ++ cfg.extraPackages;
  };
}
