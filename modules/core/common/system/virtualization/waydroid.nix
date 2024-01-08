{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;

  waydroid-ui = pkgs.writeShellScriptBin "waydroid-ui" ''
    export WAYLAND_DISPLAY=wayland-0
    ${pkgs.weston}/bin/weston -Swayland-1 --width=600 --height=1000 --shell="kiosk-shell.so" &
    WESTON_PID=$!

    export WAYLAND_DISPLAY=wayland-1
    ${pkgs.waydroid}/bin/waydroid show-full-ui &

    wait $WESTON_PID
    waydroid session stop
  '';
in {
  config = mkIf sys.virtualization.waydroid.enable {
    environment.systemPackages = with pkgs; [
      waydroid
      waydroid-ui
    ];

    virtualisation = {
      lxd.enable = sys.waydroid.enable; # TODO: make this also acceept sys.lxd.enable
      waydroid.enable = sys.waydroid.enable;
    };
  };
}
