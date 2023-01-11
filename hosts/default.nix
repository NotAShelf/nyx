{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;

  ## bootloaders ##
  bl-common = ../modules/bootloaders/common.nix; # default bootloader
  bl-server = ../modules/bootloaders/server.nix; # server-specific bootloader

  # globally shared modules
  core = ../modules/core;
  wayland = ../modules/wayland; # for devices running a wayland desktop
  server = ../modules/server; # for devices that act as "servers"
  desktop = ../modules/desktop; # for devices that are for daily use

  # hardware specific modules (and btrfs)
  intel = ../modules/hardware/intel; # surprisingly common on my devices
  nvidia = ../modules/hardware/nvidia; # currently breaks mozilla products
  amd = ../modules/hardware/amd; # soon :weary:
  laptop = ../modules/hardware/laptop; # for devices that identify as laptops
  btrfs = ../modules/hardware/btrfs; # for devices rocking a btrfs main disk

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4
  ragenix = inputs.ragenix.nixosModules.age; # secret encryption
  hmModule = inputs.home-manager.nixosModules.home-manager; # home-manager

  shared = [core ragenix];

  # home-manager configurations
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.notashelf = ../home/notashelf;
  };
in {
  # HP Pavillion from 2016
  # My main nixos profile, active on my laptop(s)
  prometheus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "prometheus";}
        ./prometheus
        bl-common
        hmModule
        desktop
        laptop
        wayland
        intel
        btrfs
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # Lenovo Ideapad from 2014
  # Portable "server"
  icarus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "icarus";}
        ./icarus
        bl-common
        server
        wayland
        hmModule
        intel
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # Raspberry Pi 400
  # My Pi400 homelab, used mostly for testing
  atlas = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules =
      [
        ./atlas
        hw.raspberry-pi-4
        server
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  gaea = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./gaea
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];
    specialArgs = {inherit inputs;};
  };
}
