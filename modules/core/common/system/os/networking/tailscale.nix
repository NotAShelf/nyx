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
      extraUpFlags = sys.tailscale.defaultFlags ++ optionals sys.tailscale.isServer ["--advertise-exit-node"];
    };

    # server can't be client and client be server
    assertions = [
      {
        assertion = cfg.isClient != cfg.isServer;
        message = ''
          You have enabled both client and server features of the Tailscale service. Unless you are providing your own UpFlags, this is probably not what you want.
        '';
      }
    ];
  };
}
