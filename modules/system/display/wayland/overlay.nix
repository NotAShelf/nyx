{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  sys = config.modules.system;
in {
  config = mkIf (cfg.enable && sys.isWayland) {
    nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];
  };
}
