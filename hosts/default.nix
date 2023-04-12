{
  nixpkgs,
  self,
  lib,
  ...
}: let
  inputs = self.inputs;

  ## bootloader ##
  boot = ../modules/boot;
  # system module will choose the appropriate bootloader based on device.type option

  # globally shared modules
  core = ../modules/core; # the self-proclaimed sane defaults for all my systems
  server = ../modules/server; # for devices that act as "servers"
  desktop = ../modules/desktop; # for devices that are for daily use
  virtualization = ../modules/virtualization; # hotpluggable virtalization module
  system = ../modules/system; # system module for configuring system-specific options easily

  homes = ../home; # home-manager configurations for hosts that need home-manager

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other devices
  ragenix = inputs.ragenix.nixosModules.age; # secret encryption via age
  sops = inputs.sops-nix.nixosModules.sops; # secret encryption based on sops

  home-manager = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  shared = [system core ragenix sops boot];
in {
  # My main desktop boasting a RX 6700 XT and Ryzen 5 3600x
  # fully free from nvidia
  # fuck nvidia - Linus "the linux" Torvalds
  enyo = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "enyo";}
        ./enyo
        desktop
        home-manager
        virtualization
        homes
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  # HP Pavillion from 2016
  # My main nixos profile, active on my laptop(s)
  prometheus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "prometheus";}
        ./prometheus
        desktop
        home-manager
        virtualization
        homes
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  epimetheus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "epimetheus";}
        ./epimetheus
        desktop
        home-manager
        virtualization
        homes
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  janus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "janus";}
        ./janus
        virtualization
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  # Lenovo Ideapad from 2014
  # Portable "server"
  icarus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "icarus";}
        ./icarus
        desktop
        home-manager
        homes
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
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
    specialArgs = {inherit inputs self;};
  };
}
