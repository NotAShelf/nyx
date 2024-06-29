{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkGraphicalService;
  inherit (lib.modules) mkIf;

  inherit (osConfig) meta modules;
  dev = modules.device;
  sys = modules.system;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((elem dev.type acceptedTypes) && (sys.video.enable && meta.isWayland)) {
    /*
    services = {
      nextcloud-client.enable = true;
      nextcloud-client.startInBackground = true;
    };
    */

    home.packages = [pkgs.nextcloud-client];
    systemd.user.services.nextcloud = mkGraphicalService {
      Unit.Description = "Nextcloud client service";
      Service = {
        ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
        Restart = "always";
        Slice = "background.slice";
      };
    };
  };
}
