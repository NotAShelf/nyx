{
  config,
  pkgs,
  inputs,
  ...
}: {
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
    keyMap = "trq";
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
  ];

  # Set timezone
  time.timeZone = "Europe/Istanbul";

  system.stateVersion = "22.05"; # DONT TOUCH THIS
}
