{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;

  ## bootloaders ##
  bl-common = ../modules/bootloaders/common.nix; # default bootloader
  bl-server = ../modules/bootloaders/server.nix; # server-specific bootloader

  ## shared modules ##

  # global
  core = ../modules/core;
  wayland = ../modules/wayland; # for devices running a wayland desktop
  server = ../modules/server; # for devices that act as "servers"
  desktop = ../modules/desktop; # for devices that are for daily use, i.e laptops

  # hardware modules
  nvidia = ../modules/hardware/nvidia; # currently breaks mozilla products
  intel = ../modules/hardware/intel; # surprisingly common on my devices
  amd = ../modules/hardware/amd; # soon :weary:

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4
  ragenix = inputs.ragenix.nixosModules.age; # secret encryption
  hmModule = inputs.home-manager.nixosModules.home-manager; # home-manager

  shared = [core ragenix];
  hybrid = [intel nvidia];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.notashelf = ../modules/home/notashelf;
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
        desktop
        wayland
        intel
        hmModule
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
        bl-server
        hw.raspberry-pi-4
        server
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };
}
