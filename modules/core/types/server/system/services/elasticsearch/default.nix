{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.elasticsearch.enable {
    services.elasticsearch = {
      enable = true;
      single_node = true;
      cluster_name = "elasticsearch-${config.networking.hostName}";

      extraConf = ''
        xpack.security.enabled: false
      '';
    };
  };
}
