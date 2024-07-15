{
  self',
  inputs,
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  imports = [inputs.schizofox.homeManagerModule];
  config = mkIf prg.firefox.enable {
    programs.schizofox = {
      enable = true;

      theme = {
        font = "Inter";
        colors = {
          background-darker = "181825";
          background = "1e1e2e";
          foreground = "cdd6f4";
        };
      };

      search = rec {
        defaultSearchEngine = "Searxng";
        removeEngines = ["Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia" "LibRedirect" "DuckDuckGo"];
        searxUrl = "https://search.notashelf.dev";
        searxQuery = "${searxUrl}/search?q={searchTerms}&categories=general";
        addEngines = [
          {
            Name = "Searxng";
            Description = "Decentralized search engine";
            Alias = "sx";
            Method = "GET";
            URLTemplate = "${searxQuery}";
          }
        ];
      };

      security = {
        sanitizeOnShutdown = false;
        sandbox = true;
        noSessionRestore = false;
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      };

      misc = {
        drm.enable = true;
        disableWebgl = false;
        startPageURL = "file://${self'.packages.schizofox-startpage.outPath}/index.html";
        bookmarks = [
          {
            Title = "Noogle";
            URL = "https://noogle.dev";
            Placement = "toolbar";
          }
          {
            Title = "Nixpkgs Manual";
            URL = "https://nixos.org/manual/nixpkgs/stable";
            Placement = "toolbar";
          }
        ];
      };

      extensions = {
        simplefox.enable = true;
        darkreader.enable = true;

        enableDefaultExtensions = true;
        enableExtraExtensions = true;
        extraExtensions = let
          extensions = [
            {
              id = "1018e4d6-728f-4b20-ad56-37578a4de76";
              name = "flagfox";
            }
            {
              id = "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}";
              name = "auto-tab-discard";
            }
            {
              id = "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}";
              name = "refined-github-";
            }
            {
              id = "sponsorBlocker@ajay.app";
              name = "sponsorblock";
            }
            {
              id = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
              name = "bitwarden-password-manager";
            }
            {
              id = "{74145f27-f039-47ce-a470-a662b129930a}";
              name = "clearurls";
            }
            {
              id = "{b86e4813-687a-43e6-ab65-0bde4ab75758}";
              name = "localcdn-fork-of-decentraleyes";
            }
            {
              id = "smart-referer@meh.paranoid.pk";
              name = "smart-referer";
            }
            {
              id = "skipredirect@sblask";
              name = "skip-redirect";
            }
            {
              id = "7esoorv3@alefvanoon.anonaddy.me";
              name = "libredirect";
            }
            {
              id = "DontFuckWithPaste@raim.ist";
              name = "dont-fuck-with-paste";
            }
          ];

          mappedExtensions =
            map (extension: {
              name = extension.id;
              value = {
                # installation_mode = "force_installed";
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${extension.name}/latest.xpi";
              };
            })
            extensions;
        in
          listToAttrs mappedExtensions;
      };
    };
  };
}
