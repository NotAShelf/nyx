{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;

  dev = osConfig.modules.device;
  sys = osConfig.modules.system;
  cfg = osConfig.modules.style;

  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes && sys.video.enable) {
    qt = {
      enable = true;
      platformTheme.name = mkIf cfg.forceGtk "gtk"; # just an override for QT_QPA_PLATFORMTHEME, takes “gtk”, “gnome”, “qtct” or “kde”

      style = mkIf (!cfg.forceGtk) {
        name = cfg.qt.theme.name;
        package = cfg.qt.theme.package;
      };
    };

    /*
    home.packages = with pkgs;
      [
        libsForQt5.qt5ct
        breeze-icons

        # libraries to ensure that "gtk" platform theme works
        # as intended after the following PR:
        # <https://github.com/nix-community/home-manager/pull/5156>
        libsForQt5.qtstyleplugins
        qt6Packages.qt6gtk2

        # add theme package to path just in case
        cfg.qt.theme.package
      ]
      ++ optionals cfg.useKvantum [
        qt6Packages.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugin-kvantum
      ];
    */

    home = {
      packages = with pkgs;
        mkMerge [
          [
            # libraries and programs to ensure that qt applications load without issue
            # breeze-icons is added as a fallback
            libsForQt5.qt5ct
            kdePackages.qt6ct
            breeze-icons
          ]

          (mkIf cfg.forceGtk [
            # libraries to ensure that "gtk" platform theme works
            # as intended after the following PR:
            # <https://github.com/nix-community/home-manager/pull/5156>
            libsForQt5.qtstyleplugins
            qt6Packages.qt6gtk2
          ])

          (mkIf cfg.useKvantum [
            # kvantum as a library and a program to theme qt applications
            # this added here, however, this will not have an effect
            # until QT_QPA_PLATFORMTHEME has been set appropriately
            # we still write the config files for kvantum below
            # but again, it is a no-op until the env var is set
            qt6Packages.qtstyleplugin-kvantum
            libsForQt5.qtstyleplugin-kvantum
          ])
        ];

      sessionVariables = {
        # scaling - 1 means no scaling
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";

        # use wayland as the default backend, fallback to xcb if wayland is not available
        QT_QPA_PLATFORM = "wayland;xcb";

        # disable window decorations everywhere
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        # remain backwards compatible with qt5
        DISABLE_QT5_COMPAT = "0";

        # tell calibre to use the dark theme, because the light one hurts my eyes
        CALIBRE_USE_DARK_PALETTE = "1";
      };
    };

    # write files required by KDE and kvantum
    # those are not used if the user does not use KDE toolkits
    # or kvantum respectively. we set those regardless
    xdg.configFile = let
      baseGhUrl = "https://raw.githubusercontent.com/catppuccin/Kvantum";
    in {
      # write ~/.config/kdeglobals based on the kdeglobals file the user has specified
      # this option is a catch-all and not a set path because some programs specify different
      # paths inside their kdeglobals package
      "kdeglobals".source = cfg.qt.kdeglobals.source;

      "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
        General.theme = "catppuccin";
        Applications.catppuccin = ''
          qt5ct, org.kde.dolphin, org.kde.kalendar, org.qbittorrent.qBittorrent, hyprland-share-picker, dolphin-emu, Nextcloud, nextcloud, cantata, org.kde.kid3-qt
        '';
      };

      "Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
        url = "${baseGhUrl}/main/src/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.kvconfig";
        sha256 = "1f8xicnc5696g0a7wak749hf85ynfq16jyf4jjg4dad56y4csm6s";
      };

      "Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
        url = "${baseGhUrl}/main/src/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.svg";
        sha256 = "0vys09k1jj8hv4ra4qvnrhwxhn48c2gxbxmagb3dyg7kywh49wvg";
      };
    };
  };
}
