{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault optionals;
  inherit (config.services) tailscale;

  sys = config.modules.system.networking;
  cfg = sys.tailscale;
in {
  config = mkIf cfg.enable {
    # make the tailscale command usable to users
    environment.systemPackages = [pkgs.tailscale];

    networking.firewall = {
      # always allow traffic from the designated tailscale interface
      trustedInterfaces = ["${tailscale.interfaceName}"];
      checkReversePath = "loose";

      # allow
      allowedUDPPorts = [tailscale.port];
    };

    # enable tailscale, inter-machine VPN service
    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = mkDefault "both";
      # TODO: these actually need to be specified with `tailscale up`
      extraUpFlags = cfg.defaultFlags ++ optionals cfg.isServer ["--advertise-exit-node"];
    };

    # lets not send our logs to log.tailscale.io
    # unless I get to know what they do with the logs
    systemd = {
      services.tailscaled.serviceConfig.Environment = lib.mkBefore [
        "TS_NO_LOGS_NO_SUPPORT=true"
      ];

      network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];
    };
  };
}
