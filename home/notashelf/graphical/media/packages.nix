{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
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
      mov-cli
      ani-cli
    ];
  };
}
