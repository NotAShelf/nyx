{
  pkgs,
  lib,
  osConfig,
  self,
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
      # get ani-cli and mov-cli from my own derivations
      # I don't want to wait for nixpkgs
      self.packages.${pkgs.hostPlatform.system}.mov-cli
      self.packages.${pkgs.hostPlatform.system}.ani-cli
    ];
  };
}
