{
  inputs',
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
  cfg = prg.media;
in {
  config = mkIf cfg.addDefaultPackages {
    home.packages = with pkgs;
      [
        # tools that help with media operations/management
        ffmpeg-full
        yt-dlp
        mpc-cli
        playerctl
        pavucontrol
        pulsemixer
        imv
        cantata
        easytag
        kid3
        musikcube

        # get ani-cli  from my own package collection
        # I usually don't want to wait for nixpkgs
        inputs'.nyxexprs.packages.ani-cli
      ]
      ++ cfg.extraPackages;
  };
}
