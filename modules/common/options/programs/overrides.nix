{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  # this module provides overrides for certain defaults and lets you set
  # default programs for referencing in other config files.
  options.modules = {
    # "override" is a simple option that sets the programs' state to the oppossite of their default
    # service overrides
    services.override = {
      nextcloud = mkEnableOption "Override Nextcloud service";
      mailserver = mkEnableOption "Override nixos-mailserver service";
      mkm = mkEnableOption "Override mkm-ticketing service";
      vaultwarden = mkEnableOption "Override VaultWarden service";
      gitea = mkEnableOption "Override Gitea service";
      grafana = mkEnableOption "Override Grafana and Prometheus services";
      irc = mkEnableOption "Override Quassel IRC service";
      jellyfin = mkEnableOption "Override Jellyfin media service";
      matrix = mkEnableOption "Override Matrix-synapse service";
      wireguard = mkEnableOption "Override Wireguard service";
      searxng = mkEnableOption "Override Searxng service";
      database = {
        mysql = mkEnableOption "Override MySQL database service";
        mongodb = mkEnableOption "Override MongoDB service";
        redis = mkEnableOption "Override Redis service";
        postgresql = mkEnableOption "Override Postgresql service";
      };
    };

    programs.override = {
      # override basic desktop applications
      # an example override for the libreoffice program
      # if set to true, libreoffice module will not be enabled as it is by default
      libreoffice = mkEnableOption "Override Libreoffice suite";
    };
  };
}
