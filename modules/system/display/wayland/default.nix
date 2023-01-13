{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  sys = config.modules.system;
in {
  config = mkMerge [
    (mkIf (cfg.enable && sys.isWayland) {
      nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];

      imports = [
        ./environment.nix
        ./portals.nix
        ./services.nix
      ];
    })
  ];
}
