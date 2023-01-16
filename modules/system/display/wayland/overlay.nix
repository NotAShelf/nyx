{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  env = config.modules.usrEnv;
in {
  config = mkIf (cfg.enable && env.isWayland) {
    nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];
  };
}
