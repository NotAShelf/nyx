{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  inherit (lib) optionalString mkDefault;
in {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/installer/cd-dvd/iso-image.nix"

    ./boot.nix
    ./iso.nix
    ./network.nix
    ./nix.nix
    ./ssh.nix
  ];

  users.extraUsers.root.password = "";

  users.users = {
    nixos = {
      uid = 1000;
      password = "nixos";
      description = "default";
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  # console locale #
  console = let
    variant = "u24n";
  in {
    # hidpi terminal font
    font = "${pkgs.terminus_font}/share/consolefonts/ter-${variant}.psf.gz";
    keyMap = "trq";
  };

  # attempt to fix "too many open files"
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "65536";
    }
  ];

  services.getty.helpLine =
    ''
      The "nixos" and "root" accounts have empty passwords.
      An ssh daemon is running. You then must set a password
      for either "root" or "nixos" with `passwd` or add an ssh key
      to /home/nixos/.ssh/authorized_keys be able to login.
      If you need a wireless connection, you may use networkmanager
      by invoking `nmcli` or `nmtui`, the ncurses interface.
    ''
    + optionalString config.services.xserver.enable ''
      Type `sudo systemctl start display-manager' to
      start the graphical user interface.
    '';

  # borrow some environment options from the minimal profile to save space
  environment = {
    noXlibs = mkDefault true; # trim inputs

    # no packages other than my defaults
    defaultPackages = [];

    # system packages for the base installer
    systemPackages = with pkgs; [
      nixos-install-tools
      gitMinimal
      neovim
      netcat
    ];

    # fix an annoying warning
    etc."mdadm.conf".text = ''
      MAILADDR root
    '';
  };

  # disable documentation to save space
  documentation = {
    enable = mkDefault false;
    doc.enable = mkDefault false;
    info.enable = mkDefault false;
  };

  # disable fontConfig to save space, we don't have a graphical environment on the ISO
  fonts.fontconfig.enable = lib.mkForce false;

  # disable sound related programs
  sound.enable = false;

  # provide all hardware drivers, including proprietary ones
  hardware.enableRedistributableFirmware = true;

  # since we don't inherit the core module, this needs to be set here manually
  # otherwise we'll see the stateVersion error - which doesn't actually matter inside the ISO
  # but still annoying and slows down nix flake check
  system.stateVersion = "23.11";
}
