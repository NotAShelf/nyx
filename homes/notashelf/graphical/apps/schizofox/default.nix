{
  lib,
  inputs,
  osConfig,
  ...
}: {
  imports = [inputs.schizofox.homeManagerModule];
  config = lib.mkIf osConfig.modules.usrEnv.programs.firefox.enable {
    programs.schizofox = lib.mkIf (osConfig.modules.usrEnv.programs.firefox.client == "schizofox") {
      enable = true;

      theme = {
        background-darker = "181825";
        background = "1e1e2e";
        foreground = "cdd6f4";
        font = "Lexend";
        simplefox.enable = true;
        darkreader.enable = true;
        extraCss = ''
          body {
            color: red !important;
          }
        '';
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
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      };

      misc = {
        drmFix = true;
        disableWebgl = false;
        startPageURL = "file://${./startpage.html}";
      };

      extensions.extraExtensions = {
        "1018e4d6-728f-4b20-ad56-37578a4de76".install_url = "https://addons.mozilla.org/firefox/downloads/latest/flagfox/latest.xpi";
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
        "sponsorBlocker@ajay.app".install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      };

      bookmarks = [
        {
          Title = "Nyx";
          URL = "https://github.com/NotAShelf/nyx";
          Placement = "toolbar";
          Folder = "Github";
        }
      ];
    };
  };
}
