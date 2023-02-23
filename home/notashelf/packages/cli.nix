{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "server" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
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
      docker-compose
      docker-credential-helpers
      xorg.xhost
      nitch
      fastfetch
      binwalk
      binutils
      diffoscope
      nmap
    ];
  };
}
