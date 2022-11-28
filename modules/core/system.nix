{
  config,
  pkgs,
  ...
}: {
  services = {
    thermald.enable = true;
    dbus = {
      packages = with pkgs; [dconf];
      enable = true;
    };
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
      gnome.seahorse
      dolphinEmu
    ];
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      neovim
      git
      curl
      wget
    ];

    variables = {
      EDITOR = "nvim";
    };
  };

  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u24n.psf.gz";
    keyMap = "trq";
  };

  programs = {
    bash.promptInit = ''
      eval "${pkgs.starship}/bin/starship init bash"
    '';
  };

  # Systemd OOMd
  # Fedora enables these options by default. See the 10-oomd-* files here:
  # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
  systemd.oomd = {
    enableRootSlice = true;
    enableUserServices = true;
  };
}
