# jebait agressive port scanners by wasting their time with connection that'll never make it in
# this *does* have performance implications, however, so be careful which hosts you enable it for
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.networking.tarpit;
in {
  config = mkIf cfg.enable {
    services.endlessh-go = {
      enable = true;
      port = 22;
      openFirewall = true;

      extraOptions = [
        "-alsologtostderr"
        "-geoip_supplier max-mind-db"
        "-max_mind_db ${pkgs.clash-geoip}/etc/clash/Country.mmdb"
      ];

      prometheus = {
        enable = true;
        port = 9105;
      };
    };
  };
}
