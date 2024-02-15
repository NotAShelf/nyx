{lib, ...}: let
  inherit (lib) mkEnableOption mkModule;
in {
  imports = [
    ./bincache.nix
    ./databases.nix
    ./monitoring.nix
    ./networking.nix
    ./social.nix
  ];

  options.modules.system = {
    services = {
      mailserver.enable = mkEnableOption "nixos-mailserver service";
      mkm.enable = mkEnableOption "mkm-ticketing service";

      nextcloud = mkModule {
        name = "Nextcloud";
        type = "cloud storage";
      };

      nginx = mkModule {
        name = "Nginx";
        type = "webserver";
      };

      vaultwarden = mkModule {
        name = "Vaultwarden";
        type = "password manager";
        port = 8222;
        host = "127.0.0.1";
      };

      forgejo = mkModule {
        name = "Forgejo";
        type = "forge";
        port = 7000;
      };

      quassel = mkModule {
        name = "Quassel";
        type = "IRC";
        port = 4242;
      };

      jellyfin = mkModule {
        name = "Jellyfin";
        type = "media";
        port = 8096;
      };

      searxng = mkModule {
        name = "Searxng";
        type = "meta search engine";
        port = 8888;
      };

      miniflux = mkModule {
        name = "Miniflux";
        type = "RSS reader";
      };

      reposilite = mkModule {
        name = "Reposilite";
        port = 8084;
      };

      elasticsearch = mkModule {
        name = "Elasticsearch";
        port = 9200;
      };

      kanidm = mkModule {
        name = "Kanidm";
        port = 8443;
      };
    };
  };
}
