{
  pkgs,
  lib,
  config,
  ...
}: let
  browser = ["firefox.desktop"];

  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/discord" = ["WebCord.desktop"];
  };
in {
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableZshIntegration = true;
  };

  programs = {
    bat = {
      enable = true;
      themes = {
        Catppuccin-frappe = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "00bd462e8fab5f74490335dcf881ebe7784d23fa";
            sha256 = "yzn+1IXxQaKcCK7fBdjtVohns0kbN+gcqbWVE4Bx7G8=";
          }
          + "/Catppuccin-frappe.tmTheme");
      };
      config.theme = "Catppuccin-frappe";
    };
    #programs.gpg = {
    #  settings = mkIf (cfg.key != "") {
    #   default-key = cfg.key;
    #   default-recipient-self = true;
    #   auto-key-locate = "local,wkd,keyserver";
    #   keyserver = "hkps://keys.openpgp.org";
    #   auto-key-retrieve = true;
    #   auto-key-import = true;
    #   keyserver-options = "honor-keyserver-url";
    #};

    # publicKeys = map (source: {
    #   inherit source;
    #   trust = "ultimate";
    # }) (attrValues (util.map.files ../secrets/keys id ".gpg"));
    #};
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      videos = "$HOME/Media/Videos";
      music = "$HOME/Media/Music";
      pictures = "$HOME/Media/Pictures";
      desktop = "$HOME/Desktop";
      publicShare = "$HOME/Public/Share";
      templates = "$HOME/Public/Templates";

      # Custom Directories
      extraConfig = {
        XDG_CACHE_DIR = "$HOME/.cache";
        XDG_DEV_DIR = "$HOME/Dev";
        XDG_SCREENSHOTS_DIR = "$HOME/Media/Pictures/Screenshots";
      };
    };

    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.associations.added = associations;
    mimeApps.defaultApplications = associations;
    configFile."mimeapps.list".force = true;
  };
}
