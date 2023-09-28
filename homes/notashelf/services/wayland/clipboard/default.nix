{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  video = osConfig.modules.system.video;
  env = osConfig.modules.usrEnv;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (video.enable && env.isWayland)) {
    systemd.user.services = {
      cliphist = lib.mkGraphicalService {
        Unit.Description = "Clipboard history service";
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store";
          Restart = "always";
        };
      };

      wl-clip-persist = lib.mkGraphicalService {
        Unit.Description = "Persistent clipboard for Wayland";
        Service = {
          ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
          Restart = "always";
        };
      };
    };
  };
}
