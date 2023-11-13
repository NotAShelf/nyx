{
  self,
  lib,
  withSystem,
  ...
}: let
  inherit (self) inputs;

  # mkNixosIso and mkNixosSystem are my own builders for assembling a nixos system
  inherit (lib) concatLists mkNixosIso mkNixosSystem;

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other quirky devices
  agenix = inputs.agenix.nixosModules.default; # secret encryption via age
  hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  # serializing the modulePath to a variable
  # this is incase the modulePath changes depth (i.e modules becomes nixos/modules)
  modulePath = ../modules;

  # common modules, to be shared across all systems
  coreModules = modulePath + /core; # the path where common modules reside
  options = coreModules + /options; # the module that provides the options for my system configuration
  common = coreModules + /common; # the self-proclaimed sane defaults for all my systems
  workstation = coreModules + /types/workstation; # for devices that are of workstation type - any device that is for daily use
  server = coreModules + /types/server; # for devices that are of the server type - provides online services
  laptop = coreModules + /types/laptop; # for devices that are of the laptop type - provides power optimizations

  # extra modules - optional but likely critical to a successful build
  extraModules = modulePath + /extra; # the path where extra modules reside
  sharedModules = extraModules + /shared; # the path where shared modules reside

  # profiles
  profiles = modulePath + /profiles; # profiles force enable certain options for quick configurations

  # home-manager #
  homesDir = ../homes; # home-manager configurations for hosts that need home-manager
  homes = [hm homesDir]; # combine hm flake input and the home module to be imported together

  # a list of shared modules that ALL systems need
  shared = [
    common # the "sane" default shared across systems
    profiles # a profile module to provide configuration sets per demand
    options # provide options for defined modules across the system
    sharedModules # consume my flake's own nixosModules
    agenix # age encryption for secrets
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
  # superseded by epimetheus
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

  # Twin host for prometheus
  # provides full disk encryption with passkey/USB auth
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

  # Lenovo Ideapad from 2014
  # Hybrid device, acts as a portable server and a "workstation"
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

  # Self-made live recovery environment that overrides or/and configures certain default programs
  # provides tools and fixes the keymaps for my keyboard
  gaea = mkNixosIso {
    system = "x86_64-linux";
    modules = [
      # import base iso configuration on top of base nixos modules for the live installer
      ./gaea
    ];
    specialArgs = sharedArgs;
  };

  # an air-gapped nixos liveiso to deal with yubikeys
  # isolated from all networking
  erebus = mkNixosIso {
    inherit withSystem;
    system = "x86_64-linux";
    modules = [
      ./erebus
    ];
    specialArgs = {inherit inputs self lib;};
  };

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

  # Apollon is also x86_64-linux
  # but is for testing server-specific services
  apollon = mkNixosSystem {
    inherit withSystem;
    system = "aarch64-linux";
    modules =
      [
        {networking.hostName = "apollon";}
        ./apollon
        server
      ]
      ++ shared;
    specialArgs = sharedArgs;
  };
}
