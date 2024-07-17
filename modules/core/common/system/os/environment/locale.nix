{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };

  i18n = let
    defaultLocale = "en_US.UTF-8";
    tr = "tr_TR.UTF-8";
  in {
    inherit defaultLocale;

    extraLocaleSettings = {
      LANG = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_CTYPE = defaultLocale;
      LC_MESSAGES = defaultLocale;

      LC_ADDRESS = tr;
      LC_IDENTIFICATION = tr;
      LC_MEASUREMENT = tr;
      LC_MONETARY = tr;
      LC_NAME = tr;
      LC_NUMERIC = tr;
      LC_PAPER = tr;
      LC_TELEPHONE = tr;
      LC_TIME = tr;
    };

    supportedLocales = mkDefault [
      "en_US.UTF-8/UTF-8"
      "tr_TR.UTF-8/UTF-8"
    ];

    # IME configuration
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-lua
        libsForQt5.fcitx5-qt

        # themes
        fcitx5-material-color
      ];
    };
  };
}
