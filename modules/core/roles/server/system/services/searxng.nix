{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;

  port = cfg.searxng.port or 8888;
in {
  config = mkIf cfg.searxng.enable {
    networking.firewall.allowedTCPPorts = [port];

    modules.system.services = {
      nginx.enable = true;
      database.redis.enable = true;
    };

    users = {
      users.searx = {
        isSystemUser = true;
        createHome = false;
        group = lib.mkForce "searx-redis";
      };

      groups.searx-redis = {};
    };

    services = {
      searx = {
        enable = true;
        package = pkgs.searxng;
        environmentFile = config.age.secrets.searx-secretkey.path;
        settings = {
          use_default_settings = true;

          general = {
            instance_name = "NotASearx";
            debug = false;
            privacypolicy_url = false;
            donation_url = "https://ko-fi.com/notashelf";
            contact_url = "mailto:raf@notashelf.dev";
            enable_metrics = true;
            formats = ["json" "rss"];
          };

          ui = {
            query_in_title = true;
            results_on_new_tab = false;
          };

          search = {
            safe_search = 1; # 0 = None, 1 = Moderate, 2 = Strict
            autocomplete = "google"; # Existing autocomplete backends: "dbpedia", "duckduckgo", "google", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off by default
            default_lang = "en";
          };

          server = {
            inherit port;
            secret_key = "@SEARX_SECRET_KEY@"; # set in the environment file
            limiter = false;
            image_proxy = false; # no thanks, lol
          };

          redis = {
            #url = "unix:///run/redis-searxng/redis.sock?db=0";
            url = "redis://searxng@localhost:6370/0";
          };

          outgoing = {
            request_timeout = 10.0;
            useragent_suffix = "sx";
          };

          engines = [
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
              name = "google";
              engine = "google";
              shortcut = "g";
              use_mobile_ui = false;
            }
            {
              name = "archwiki";
              engine = "archlinux";
              shortcut = "aw";
            }
            {
              name = "github";
              engine = "github";
              categories = "it";
              shortcut = "gh";
            }
            {
              name = "noogle";
              engine = "google";
              categories = "it";
              shortcut = "ng";
            }
            {
              name = "hoogle";
              engine = "xpath";
              search_url = "https://hoogle.haskell.org/?hoogle={query}&start={pageno}";
              results_xpath = "//div[@class=\"result\"]";
              title_xpath = "./div[@class=\"ans\"]";
              url_xpath = "./div[@class=\"ans\"]//a/@href";
              content_xpath = "./div[contains(@class, \"doc\")]";
              categories = "it";
              shortcut = "h";
            }
          ];
        };
      };

      nginx.virtualHosts."search.notashelf.dev" =
        {
          locations."/".proxyPass = "http://127.0.0.1:${toString port}";
          extraConfig = ''
            access_log /dev/null;
            error_log /dev/null;
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;
          '';
        }
        // lib.sslTemplate;
    };
  };
}
