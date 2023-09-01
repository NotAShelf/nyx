{
  lib,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  inherit (osConfig.modules.system) video;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && video.enable) {
    home.packages = [pkgs.nextcloud-client];

    # control nextcloud as a systemd service, it will be stopped while in performance mode
    systemd.user.services.nextcloud = lib.mkGraphicalService {
      Unit.Description = "Nextcloud client service";
      Service = {
        ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
        Restart = "always";
        Slice = "background.slice";
      };
    };
  };
}
