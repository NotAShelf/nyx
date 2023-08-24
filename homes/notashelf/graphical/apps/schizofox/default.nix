{
  config,
  lib,
  inputs,
  osConfig,
  ...
}:
with lib; let
  inherit (osConfig.modules) device;
  acceptedTypes = ["desktop" "laptop" "hybrid"];
in {
  imports = [inputs.schizofox.homeManagerModule];
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs.schizofox = {
      enable = true;

      theme = {
        background-darker = "181825";
        background = "1e1e2e";
        foreground = "cdd6f4";
        font = "Lexend";
        extraCss = ''
          body {
            color: red !important;
          }
        '';
      };

      search = {
        defaultSearchEngine = "Searx";
        removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
        searxUrl = "https://search.notashelf.dev";
        searxQuery = "https://search.notashelf.dev/search?q={searchTerms}&categories=general";
        addEngines = [];
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
        "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
        "sponsorBlocker@ajay.app".install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        "1018e4d6-728f-4b20-ad56-37578a4de76".install_url = "https://addons.mozilla.org/firefox/downloads/latest/flagfox/latest.xpi";
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      };

      bookmarks = [
        {
          Title = "NixOS Manual";
          URL = "https://nixos.org/manual/nixos/stable/";
          Favicon = "https://nixos.org/";
          Placement = "toolbar";
          Folder = "FolderName";
        }
      ];
    };
  };
}
