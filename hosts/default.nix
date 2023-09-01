{
  self,
  lib,
  withSystem,
  ...
}: let
  inherit (self) inputs;
  inherit (lib) concatLists mkNixosIso mkNixosSystem;

  modulePath = ../modules;
  options = modulePath + /options; # the module that provides the options for my system configuration

  # common modules, to be shared across all systems
  commonModules = modulePath + /common; # the path where common modules reside
  core = commonModules + /core; # the self-proclaimed sane defaults for all my systems
  profiles = commonModules + /profiles; # profiles force enable certain options for quick configurations

  server = commonModules + /types/server; # for devices that are of the server type - provides online services
  laptop = commonModules + /types/laptop; # for devices that are of the laptop type - provides power optimizations
  desktop = commonModules + /types/desktop; # for devices that are of the desktop type - any device that is stationary

  workstation = commonModules + /types/workstation; # for devices that are of workstation type - any device that is for daily use

  # extra modules, likely optional but possibly critical
  extraModules = modulePath + /extra; # the path where extra modules reside
  sharedModules = extraModules + /shared; # the path where shared modules reside

  # profiles

  ## home-manager ##
  homesDir = ../homes; # home-manager configurations for hosts that need home-manager
  homes = [hm homesDir]; # combine hm flake input and the home module to be imported together

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other quirky devices
  agenix = inputs.agenix.nixosModules.default; # secret encryption via age
  hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  # a list of shared modules that ALL systems need
  shared = [
    core # the "sane" default shared across systems
    agenix # age encryption for secrets
    sharedModules # consume my flake's own nixosModules
    profiles # a profile module to provide configuration sets per demand
    options # provide options for defined modules across the system
  ];

  # extraSpecialArgs that all hosts need
  sharedArgs = {inherit inputs self lib;};
in {
  # My main desktop boasting a RX 6700 XT and a Ryzen 5 3600x
  # fully free from nvidia
  # fuck nvidia - Linus "the linux" Torvalds
  enyo = mkNixosSystem {
    inherit withSystem;
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "enyo";}
        ./enyo
        workstation
      ]
      ++ concatLists [shared homes];
    specialArgs = sharedArgs;
  };

  # HP Pavillion from 2016
  # My main nixos profile, active on my laptop(s)
  # superceded by epimetheus
  /*
  prometheus = mkNixosSystem {
    inherit withSystem;
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "prometheus";}
        ./prometheus
        workstation
        laptop
      ]
      ++ concatLists [shared homes];
    specialArgs = sharedArgs;
  };
  */

  # Twin host for prometheus
  # provides full disk encryption with passkey/USB auth
  /*
  epimetheus = mkNixosSystem {
    inherit withSystem;
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "epimetheus";}
        ./epimetheus
        workstation
        laptop
      ]
      ++ concatLists [shared homes];
    specialArgs = sharedArgs;
  };
  */

  # HP Pavillion laptop from 2023
  # equipped a Ryzen 7 7730U, usually acts as my portable workstation
  # similar to epimetheus, has full disk encryption with ephemeral root
  hermes = mkNixosSystem {
    inherit withSystem;
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "hermes";}
        ./hermes
        workstation
        laptop
      ]
      ++ concatLists [shared homes];
    specialArgs = sharedArgs;
  };

  # Hetzner VPS to replace my previous server machines
  # hosts some of my infrastructure
  /*
  helios = mkNixosSystem {
    inherit withSystem;
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "helios";}
        ./helios
        server
      ]
      ++ concatLists [shared homes];
    specialArgs = sharedArgs;
  };
  */

  # Lenovo Ideapad from 2014
  # Hybrid device, acts as a portable server and a "workstation"
  /*
  icarus = mkNixosSystem {
    inherit withSystem;
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "icarus";}
        ./icarus
        workstation
        laptop
      ]
      ++ concatLists [shared homes];
    specialArgs = sharedArgs;
  };


  # Raspberry Pi 400
  # My Pi400 homelab, used mostly for testing networking/cloud services
  atlas = mkNixosSystem {
    inherit withSystem;
    system = "aarch64-linux";
    modules =
      [
        ./atlas
        hw.raspberry-pi-4
      ]
      ++ shared;
    specialArgs = sharedArgs;
  };

  # Live recovery environment that overrides some default programs
  # and fixes keymap for me
  gaea = mkNixosIso {
    system = "x86_64-linux";
    modules = [
      # import base iso configuration on top of base nixos modules for the live installer
      ./gaea
    ];
    specialArgs = sharedArgs;
  };

  # an air-gapped nixos liveiso to deal with yubikeys
  erebus = mkNixosIso {
    inherit withSystem;
    system = "x86_64-linux";
    modules = [
      ./erebus
    ];
    specialArgs = {inherit inputs self lib;};
  };

  /*
  # Twin virtual machine hosts
  # Artemis is x86_64-linux
  artemis = mkNixosSystem {
    inherit withSystem;
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "artemis";}
        ./artemis
      ]
      ++ shared;
    specialArgs = sharedArgs;
  };

  # Apollon is aarch64-linux
  apollon = mkNixosSystem {
    inherit withSystem;
    system = "aarch64-linux";
    modules =
      [
        {networking.hostName = "apollon";}
        ./apollon
      ]
      ++ shared;
    specialArgs = sharedArgs;
  };
  */
}
