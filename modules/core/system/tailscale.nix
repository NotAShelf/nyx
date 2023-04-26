{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  sys = config.modules.system.networking;
in {
  config = mkIf (sys.useTailscale) {
    # make the tailscale command usable to users
    environment.systemPackages = [pkgs.tailscale];

    networking.firewall = {
      # always allow traffic from your Tailscale network
      trustedInterfaces = ["tailscale0"];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [config.services.tailscale.port];
    };

    # enable tailscale, inter-machine VPN service
    services.tailscale = {
      enable = true;
      permitCertUid = "root";
    };
  };
}
