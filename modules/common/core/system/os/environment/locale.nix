{
  pkgs,
  lib,
  ...
}: {
  time = {
    timeZone = "Europe/Istanbul";
    hardwareClockInLocalTime = true;
  };

  i18n = let
    defaultLocale = "en_US.UTF-8";
    tr = "tr_TR.UTF-8";
  in {
    inherit defaultLocale;

    extraLocaleSettings = {
      # I want my system language to be english
      LANG = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_CTYPE = defaultLocale;
      LC_MESSAGES = defaultLocale;

      # address strings, measurements, time and such should use the Turkish formatting instead of American bs
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
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "tr_TR.UTF-8/UTF-8"
    ];
  };

  console = let
    variant = "u24n";
  in {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-${variant}.psf.gz";
    keyMap = "trq";
  };
}
