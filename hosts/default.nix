{
  self,
  lib,
  ...
}: let
  inputs = self.inputs;

  commonModules = ../modules/common; # the path where common modules reside
  extraModules = ../modules/extra; # the path where extra modules reside
  sharedModules = ../modules/shared; # the path where shared modules reside

  # common modules, to be shared across all systems
  boot = commonModules + /boot; # system module will choose the appropriate bootloader based on device.type option
  core = commonModules + /core; # the self-proclaimed sane defaults for all my systems
  system = commonModules + /system; # system module for configuring system-specific options easily

  # extra modules, likely optional but possibly critical
  server = extraModules + /server; # for devices that act as "servers"
  desktop = extraModules + /desktop; # for devices that are for daily use
  virtualization = extraModules + /virtualization; # hotpluggable virtalization module

  ## home-manager ##
  home = ../home; # home-manager configurations for hosts that need home-manager
  homes = [hm home]; # combine hm flake input and the home module to be imported together

  ## profiles ##
  # TODO: shared profiles that determine things like colorscheme or power saving
  profiles = ../profiles; # profiles are pre-defined setting sets that override certain other settings as required

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other quirky devices
  agenix = inputs.agenix.nixosModules.default; # secret encryption via age
  hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  # a list of shared modules that ALL systems need
  shared = [
    system # the skeleton module for config.modules.*
    core # the "sane" default shared across systems
    agenix # age encryption for secrets
    boot # bootloader configurations + secureboot
    sharedModules # consume my flake's own nixosModules
    profiles # configure the set of defaults for the system, allow separating shared modules on a per-host basis
  ];

  # extraSpecialArgs that all hosts need
  sharedArgs = {inherit inputs self lib;};
in {
  # My main desktop boasting a RX 6700 XT and a Ryzen 5 3600x
  # fully free from nvidia
  # fuck nvidia - Linus "the linux" Torvalds
  enyo = lib.mkNixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "enyo";}
        ./enyo
        desktop
        virtualization
      ]
      ++ lib.concatLists [shared homes];
    # specialArgs = {inherit inputs self lib profiles;};
    specialArgs = sharedArgs;
  };

  # HP Pavillion from 2016
  # My main nixos profile, active on my laptop(s)
  # superceded by epimetheus
  prometheus = lib.mkSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "prometheus";}
        ./prometheus
        desktop
        virtualization
      ]
      ++ lib.concatLists [shared homes];
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
        virtualization
      ]
      ++ lib.concatLists [shared homes];
    specialArgs = {inherit inputs self lib;};
  };

  # HP Pavillion laptop from 2023
  # possesess a Ryzen 7 7730U, and acts as my portable workstation
  # similar to epimetheus, has full disk encryption with ephemeral root
  hermes = lib.mkNixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "hermes";}
        ./hermes
        desktop
        virtualization
      ]
      ++ lib.concatLists [shared homes];
    specialArgs = {inherit inputs self lib;};
  };

  # Hetzner VPS to replace my previous server machines
  # hosts some of my infrastructure
  helios = lib.mkSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "helios";}
        ./helios
        server
        virtualization
      ]
      ++ lib.concatLists [shared homes];
    specialArgs = {inherit inputs self lib;};
  };

  # Lenovo Ideapad from 2014
  # Hybrid device, acts as a portable server and a "workstation"
  icarus = lib.mkSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "icarus";}
        ./icarus
        desktop
      ]
      ++ lib.concatLists [shared homes];
    specialArgs = {inherit inputs self lib;};
  };

  # Raspberry Pi 400
  # My Pi400 homelab, used mostly for testing networking/cloud services
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
    specialArgs = {inherit inputs self lib;};
  };

  # Twin virtual machine hosts
  # Artemis is x86_64-linux
  artemis = lib.mkSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "artemis";}
        ./artemis
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };

  # Apollon is aarch64-linux
  apollon = lib.mkSystem {
    system = "aarch64-linux";
    modules =
      [
        {networking.hostName = "apollon";}
        ./apollon
      ]
      ++ shared;
    specialArgs = {inherit inputs self lib;};
  };
}
