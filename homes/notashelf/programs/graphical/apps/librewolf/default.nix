{
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  # TODO: make this use the usrEnv.programs value
  # prg.librewolf.enable
  config = mkIf prg.librewolf.enable {
    programs.librewolf = {
      enable = true;
      package = prg.librewolf.wrappedPackage;
      settings =
        {
          "sidebar.position_start" = false;
          "findbar.highlightAll" = true;

          "webgl.disabled" = false;

          "ui.use_activity_cursor" = true;
          "browser.download.useDownloadDir" = true;
          "browser.tabs.insertAfterCurrent" = true;
          "browser.tabs.warnOnClose" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.quitShortcut.disabled" = true;
          "browser.urlbar.suggest.history" = false;

          # Enable HTTPS-Only Mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;

          # Privacy settings
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;

          # Disable all sorts of telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.fullscreen.autohide" = false;
          "browser.newtabpage.activity-stream.topSitesRows" = 0;
          "browser.urlbar.quickactions.enabled" = true;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter";
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
          "browser.urlbar.trimURLs" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.searches" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Allow copy to clipboard
          "middlemouse.paste" = false; # but disable paste on middle click, that's stupid
          "dom.events.asyncClipboard.clipboard Item" = true;
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.location" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.use-xdg-desktop-portal.open-uri" = 1;
          "widget.use-xdg-desktop-portal.settings" = 1;

          "privacy.donottrackheader.value" = 1;
          "findbar.modalHighlight" = true;
          "datareporting.healthreport.uploadEnabled" = false;
        }
        // prg.librewolf.extraConfig;
    };
  };
}
