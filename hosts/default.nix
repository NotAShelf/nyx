{
  self,
  lib,
  ...
}: let
  inputs = self.inputs;

  ## bootloader ##
  boot = ../modules/boot; # system module will choose the appropriate bootloader based on device.type option

  ## globally shared modules ##
  core = ../modules/core; # the self-proclaimed sane defaults for all my systems
  server = ../modules/server; # for devices that act as "servers"
  desktop = ../modules/desktop; # for devices that are for daily use
  virtualization = ../modules/virtualization; # hotpluggable virtalization module
  system = ../modules/system; # system module for configuring system-specific options easily

  ## home-manager ##
  homes = ../home; # home-manager configurations for hosts that need home-manager

  ## profiles ##
  profiles = ../profiles; # profiles are pre-defined setting sets that override certain other settings as required

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other devices
  ragenix = inputs.ragenix.nixosModules.age; # secret encryption via age
  sops = inputs.sops-nix.nixosModules.sops; # secret encryption based on sops

  home-manager = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  shared = [system core ragenix boot];
in {
  # My main desktop boasting a RX 6700 XT and Ryzen 5 3600x
  # fully free from nvidia
  # fuck nvidia - Linus "the linux" Torvalds
  enyo = lib.mkSystem {
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
  prometheus = lib.mkSystem {
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

  # Twin host for prometheus
  # provides full disk encryption with passkey/USB auth
  epimetheus = lib.mkNixosSystem {
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

  # Twin virtual machine hosts
  # both hosts inherit from leto, the retired VM host
  artemis = lib.mkSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "artemis";}
        ./leto
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  apollon = lib.mkSystem {
    system = "aarch64-linux";
    modules =
      [
        {
          networking.hostName = "apollon";
          hardware.opengl = {driSupport32Bit = lib.mkForce false;};
        }
        ./leto
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  # Lenovo Ideapad from 2014
  # Portable "server"
  icarus = lib.mkSystem {
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

  # Hetzner VPS to replace my previous server machines
  helios = lib.mkSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "helios";}
        ./helios
        server
        home-manager
        homes
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  # Raspberry Pi 400
  # My Pi400 homelab, used mostly for testing
  atlas = lib.mkNixosSystem {
    system = "aarch64-linux";
    modules =
      [
        ./atlas
        hw.raspberry-pi-4
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  # Live recovery environment that overrides some default programs
  # and fixes keymap for me
  gaea = lib.mkNixosIso {
    system = "x86_64-linux";
    modules = [
      # import base iso configuration on top of base nixos modules for the live installer
      ./gaea
    ];
    specialArgs = {inherit inputs self;};
  };
}
