{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;

  ## bootloader ##
  bootloader = ../modules/bootloader;
  # system module will choose the appropriate bootloader based on device.type option

  # globally shared modules
  core = ../modules/core; # the self-proclaimed sane defaults for all my systems
  server = ../modules/server; # for devices that act as "servers"
  desktop = ../modules/desktop; # for devices that are for daily use
  virtualization = ../modules/virtualization; # hotpluggable virtalization module

  # TODO: consider moving home module to modules/ again - it adds an extra directory I have to type to get there
  home = ../home; # home-manager configurations for hosts that need home-manager

  # system module for configuring system-specific options (i.e fs or bluetooth)
  system = ../modules/system;

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other devices
  ragenix = inputs.ragenix.nixosModules.age; # secret encryption
  home-manager = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  shared = [system core home ragenix];
in {
  # My main desktop boasting a RX 6700 XT and Ryzen 5 3600x
  # fully free from nvidia
  # fuck nvidia - Linux "the linux" Torvalds
  enyo = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "enyo";}
        ./enyo
        bootloader
        desktop
        home-manager
        virtualization
      ]
      ++ shared;
    specialArgs = {inherit inputs self;};
  };

  # HP Pavillion from 2016
  # My main nixos profile, active on my laptop(s)
  prometheus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "prometheus";}
        ./prometheus
        bootloader
        desktop
        home-manager
        virtualization
      ]
      ++ shared;
    specialArgs = {inherit inputs self;};
  };

  # Lenovo Ideapad from 2014
  # Portable "server"
  icarus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "icarus";}
        ./icarus
        bootloader
        desktop
        home-manager
      ]
      ++ shared;
    specialArgs = {inherit inputs self;};
  };

  /*
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
  */

  # Live recovery environment that overrides some default programs
  # and fixes keymap for me
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
