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

  # system module for configuring system-specific options (i.e fs or bluetooth)
  system = ../modules/system;

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4
  ragenix = inputs.ragenix.nixosModules.age; # secret encryption
  hmModule = inputs.home-manager.nixosModules.home-manager; # home-manager

  shared = [core system ragenix];

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
        wayland
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
        wayland
        hmModule
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
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  gaea = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # import base iso configuration on top of base nixos modules for the live installer
      ./gaea
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];
    specialArgs = {inherit inputs;};
  };
}
