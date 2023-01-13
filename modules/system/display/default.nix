{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  sys = config.modules.system;
in {
  config = mkMerge [
    (mkIf (sys.isWayland) {
      nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];
    })

    (mkIf (!sys.isWayland) {
      # TODO
    })
  ];
}
