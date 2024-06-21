{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;

  inherit (cfg.searxng.settings) host port;
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
            privacypolicy_url = false;
            donation_url = "https://ko-fi.com/notashelf";
            contact_url = "mailto:raf@notashelf.dev";
            enable_metrics = true;
            debug = false;
          };

          search = {
            safe_search = 2; # 0 = None, 1 = Moderate, 2 = Strict
            formats = ["html" "json" "rss"];
            autocomplete = "google"; # "dbpedia", "duckduckgo", "google", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off by default
            default_lang = "en";
          };

          server = {
            inherit port;
            method = "GET";
            secret_key = "@SEARX_SECRET_KEY@"; # set in the environment file
            limiter = false;
            image_proxy = false; # no thanks, lol
            default_http_headers = {
              X-Content-Type-Options = "nosniff";
              X-XSS-Protection = "1; mode=block";
              X-Download-Options = "noopen";
              X-Robots-Tag = "noindex, nofollow";
              Referrer-Policy = "no-referrer";
            };
          };

          ui = {
            query_in_title = true;
            theme_args.simple_style = "dark"; # auto, dark, light
            results_on_new_tab = false;
          };

          redis = {
            url = "unix://searxng:localhost@/run/redis-searxng?db=0";
            #url = "unix:///run/redis-searxng/redis.sock?db=0";
            #url = "redis://searxng@localhost:6370/0";
          };

          outgoing = {
            request_timeout = 15.0;
            max_request_timeout = 30.0;
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
              name = "nixpkgs";
              shortcut = "nx";
              engine = "elasticsearch";
              categories = "dev,nix";
              base_url = "https://nixos-search-5886075189.us-east-1.bonsaisearch.net:443";
              index = "latest-31-nixos-unstable";
              query_type = "match";
            }
          ];
        };
      };

      nginx.virtualHosts."search.notashelf.dev" =
        {
          locations."/".proxyPass = "http://${host}:${toString port}";
          extraConfig = ''
            access_log /dev/null;
            error_log /dev/null;
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;
          '';

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
