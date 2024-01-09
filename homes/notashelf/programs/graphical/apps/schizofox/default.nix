{
  self',
  inputs,
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
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
        drmFix = true;
        disableWebgl = false;
        startPageURL = "file://${self'.packages.schizofox-startpage.outPath}/index.html";
        bookmarks = [
          {
            Title = "Nyx";
            URL = "https://github.com/NotAShelf/nyx";
            Placement = "toolbar";
            Folder = "Github";
          }
        ];
      };

      extensions = {
        simplefox.enable = true;
        darkreader.enable = true;
        extraExtensions = let
          mkUrl = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
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
          ];
          extraExtensions = builtins.foldl' (acc: ext: acc // {ext.id = {install_url = mkUrl ext.name;};}) {} extensions;
        in
          extraExtensions;
      };
    };
  };
}
