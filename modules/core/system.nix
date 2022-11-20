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
    font = "Lat2-Terminus16";
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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  system.stateVersion = "22.05"; # DONT TOUCH THIS
}
