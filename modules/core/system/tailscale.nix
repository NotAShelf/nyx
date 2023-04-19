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

    # enable tailscale, inter-machine VPN service

    services.tailscale = {
      enable = true;
      permitCertUid = "root";
    };
  };
}
