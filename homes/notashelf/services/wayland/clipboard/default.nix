{
  pkgs,
  lib,
  osConfig,
  self',
  ...
}: let
  inherit (lib) mkIf isAcceptedDevice isWayland mkGraphicalService getExe;
  inherit (self'.packages) wl-clip-persist;
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((isAcceptedDevice osConfig acceptedTypes) && (isWayland osConfig)) {
    systemd.user.services = {
      cliphist = mkGraphicalService {
        Unit.Description = "Clipboard history service";
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${getExe pkgs.cliphist} store";
          Restart = "always";
        };
      };

      wl-clip-persist = mkGraphicalService {
        Unit.Description = "Persistent clipboard for Wayland";
        Service = {
          ExecStart = "${getExe wl-clip-persist} --clipboard both";
          Restart = "always";
        };
      };
    };
  };
}
