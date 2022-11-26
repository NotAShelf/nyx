{
  config,
  pkgs,
  ...
}: {
  services = {
    gvfs.enable = true;
    dbus = {
      packages = with pkgs; [dconf];
      enable = true;
    };
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
  ];

  time.timeZone = "Europe/Istanbul";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
    keyMap = "trq";
  };
}
