{config, ...}: let
  browser = ["Schizofox.desktop"];
  mailer = ["thunderbird.desktop"];
  zathura = ["org.pwmt.zathura.desktop.desktop"];
  fileManager = ["org.kde.dolphin.desktop"];

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

    "inode/directory" = fileManager;
    "application/x-xz-compressed-tar" = ["org.kde.ark.desktop"];

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = zathura;
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/discord" = ["WebCord.desktop"];
    "x-scheme-handler/mailto" = mailer;
  };
in {
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

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        XDG_DEV_DIR = "$HOME/Dev";
      };
    };

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
