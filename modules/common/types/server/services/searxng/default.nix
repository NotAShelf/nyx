{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  acceptedTypes = ["server" "hybrid"];
  port = 8888;
in {
  config = mkIf (lib.isAcceptedTypes config acceptedTypes && config.modules.services.searxng.enable) {
    networking.firewall.allowedTCPPorts = [port];

    users = {
      users.searx = {
        isSystemUser = true;
        createHome = false;
        group = lib.mkForce "searx-redis";
      };

      groups.searx-redis = {};
    };

    services.searx = {
      enable = true;
      package = pkgs.searxng;
      environmentFile = config.age.secrets.searx-secretkey.path;
      settings = {
        use_default_settings = true;

        general = {
          instance_name = "NotASearx";
          debug = false;
          privacypolicy_url = false;
          donation_url = false;
          contact_url = "mailto:raf@notashelf.dev";
          enable_metrics = true;
        };

        search = {
          safe_search = 1; # 0 = None, 1 = Moderate, 2 = Strict
          autocomplete = "google"; # Existing autocomplete backends: "dbpedia", "duckduckgo", "google", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off by default
          default_lang = "en";
        };

        server = {
          secret_key = "@SEARX_SECRET_KEY@";
          port = 8888;
          limiter = false;
          image_proxy = false; # no thanks, lol
        };

        redis = {
          #url = "unix:///run/redis-searxng/redis.sock?db=0";
          url = "redis://localhost:6370/0";
        };

        outgoing = {
          request_timeout = 10.0;
          useragent_suffix = "sx";
        };

        engines = [
          {
            name = "archwiki";
            engine = "archlinux";
            shortcut = "aw";
          }
          {
            name = "wikipedia";
            engine = "wikipedia";
            shortcut = "w";
            base_url = "https://wikipedia.org/";
          }
          {
            name = "duckduckgo";
            engine = "duckduckgo";
            shortcut = "ddg";
          }
          {
            name = "github";
            engine = "github";
            shortcut = "gh";
          }
          {
            name = "google";
            engine = "google";
            shortcut = "g";
            use_mobile_ui = false;
          }
        ];
      };
    };
  };
}
