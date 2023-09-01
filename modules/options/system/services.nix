{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.system.services = {
    nextcloud.enable = mkEnableOption "Enable Nextcloud service";
    mailserver.enable = mkEnableOption "Enable nixos-mailserver service";
    mkm.enable.enable = mkEnableOption "Enable mkm-ticketing service";
    vaultwarden.enable = mkEnableOption "Enable VaultWarden service";
    gitea.enable = mkEnableOption "Enable Gitea service";
    grafana.enable = mkEnableOption "Enable Grafana and Prometheus services";
    irc.enable = mkEnableOption "Enable Quassel IRC service";
    jellyfin.enable = mkEnableOption "Enable Jellyfin media service";
    matrix.enable = mkEnableOption "Enable Matrix-synapse service";
    wireguard.enable = mkEnableOption "Enable Wireguard service";
    searxng.enable = mkEnableOption "Enable Searxng service";
    database = {
      mysql.enable = mkEnableOption "Enable MySQL database service";
      mongodb.enable = mkEnableOption "Enable MongoDB service";
      redis.enable = mkEnableOption "Enable Redis service";
      postgresql.enable = mkEnableOption "Enable Postgresql service";
    };
  };
}
