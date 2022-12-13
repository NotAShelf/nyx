{
  pkgs,
  lib,
  ...
}: {
  time = {
    timeZone = "Europe/Istanbul";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";

    extraLocaleSettings = {
      LC_TIME = lib.mkDefault "en_US.UTF-8";
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
