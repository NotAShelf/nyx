{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  sys = config.modules.system;
  env = config.modules.usrEnv;
in {
  config = mkIf (sys.video.enable && env.isWayland) {
    nixpkgs.overlays = with inputs; [
      nixpkgs-wayland.overlay
    ];
  };
}
