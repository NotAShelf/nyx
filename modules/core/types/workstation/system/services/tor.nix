{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
in {
  services.tor = mkIf (sys.security.tor.enable) {
    enable = true;
    client.enable = true;
    client.dns.enable = true;
    torsocks.enable = true;
  };
}
