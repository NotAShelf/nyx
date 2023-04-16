{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      # CLI
      cloneit
      catimg
      duf
      todo
      hyperfine
      fzf
      file
      unzip
      ripgrep
      rsync
      imagemagick
      bandwhich
      grex
      fd
      xh
      jq
      figlet
      lm_sensors
      bitwarden-cli
      dconf
      gcc
      cmake
      trash-cli
      cached-nix-shell
      ttyper
      xorg.xhost
      nitch
      fastfetch
      libnotify
      python39Packages.requests # move
    ];
  };
}
