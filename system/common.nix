{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  configure-gtk = let
    schema = pkgs.gsettings-desktop-schemas;
    datadir = "${schema}/share/gesettings/schemas/${schema.name}";
  in
    pkgs.writeShellScriptBin "configure-gtk" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gesettings set $gnome_schema gtk-theme 'Adwaita'
    '';
in {
  # disabledModules = [ "services/hardware/udev.nix" ];
  imports = [
    ./bootloader.nix
    ./fonts.nix
    ./network.nix
    ./security.nix
    ./blocker.nix
    ./services.nix
    ./nix.nix
  ];

  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  services.dbus = {
    enable = true;
    packages = [pkgs.dconf];
  };
  services.udev.packages = [pkgs.gnome.gnome-settings-daemon];

  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
    configure-gtk
    git
    glib
    greetd.gtkgreet
    #cryptsetup
  ];

  environment.defaultPackages = []; # this removes bloat (not really)
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # saves space
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "trq";
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  programs = {
    ccache.enable = true;
    less.enable = true;
    hyprland = {
      enable = true;
    };
  };

  environment = {
    etc = {
      "nix/flake-channels/system".source = inputs.self;
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.home-manager;
      "greetd/environments".text = ''
        Hyprland
        sway
        zsh
      '';
    };
  };

  # Set timezone
  time.timeZone = "Europe/Istanbul";

  users.users.notashelf = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "input"
      "lp"
      "networkmanager"
      "systemd-journal"
      "video"
      "wheel"
    ];
    uid = 1001;
    shell = pkgs.zsh;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  programs.light.enable = true;

  system.stateVersion = "22.05"; # DONT TOUCH THIS
}
