{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optionals;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.meta) getExe;

  sys = config.modules.system;

  inherit (sys.networking) wireless;
in {
  config = {
    environment.systemPackages = optionals (wireless.backend == "iwd") pkgs.iwgtk;
    networking.wireless =
      {
        enable = wireless.backend == "wpa_supplicant";

        # configure iwd
        iwd = {
          enable = wireless.backend == "iwd";
          settings = {
            #Rank.BandModifier5Ghz = 2.0;
            #Scan.DisablePeriodicScan = true;
            Settings.AutoConnect = true;

            General = {
              AddressRandomization = "network";
              AddressRandomizationRange = "full";
              EnableNetworkConfiguration = true;
              RoamRetryInterval = 15;
            };

            Network = {
              EnableIPv6 = true;
              RoutePriorityOffset = 300;
              # NameResolvingService = "resolvconf";
            };
          };
        };
      }
      // optionalAttrs wireless.allowImperative {
        # Imperative Configuration
        userControlled.enable = true;
        allowAuxiliaryImperativeNetworks = true; # patches wpa_supplicant

        extraConfig = ''
          update_config=1
        '';
      };

    # launch indicator as a daemon on login if wireless backend
    # is defined as iwd
    systemd = {
      # make sure we ensure the existence of wpa_supplicant config
      # before we run the wpa_supplicant service
      services.wpa_supplicant.preStart = ''
        touch /etc/wpa_supplicant.conf
      '';

      user.services.iwgtk = mkIf (wireless.backend == "iwd") {
        serviceConfig.ExecStart = "${getExe pkgs.iwgtk} -i";
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
      };
    };
  };
}
