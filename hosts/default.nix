{
  withSystem,
  inputs,
  ...
}: let
  # self.lib is an extended version of nixpkgs.lib
  # mkNixosIso and mkNixosSystem are my own builders for assembling a nixos system
  # provided by my local extended library
  inherit (inputs.self) lib;
  inherit (lib) concatLists mkNixosIso mkNixosSystem;

  ## flake inputs ##
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other quirky devices
  agenix = inputs.agenix.nixosModules.default; # secret encryption via age
  hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  # serializing the modulePath to a variable
  # this is in case the modulePath changes depth (i.e modules becomes nixos/modules)
  modulePath = ../modules;

  coreModules = modulePath + /core; # the path where common modules reside
  extraModules = modulePath + /extra; # the path where extra modules reside
  options = modulePath + /options; # the module that provides the options for my system configuration

  # common modules
  # to be shared across all systems without exception
  common = coreModules + /common; # the self-proclaimed sane defaults for all my systems
  profiles = coreModules + /profiles; # force defaults based on selected profile

  # roles
  iso = coreModules + /roles/iso; # for providing a uniform ISO configuration for live systems - only the build setup
  headless = coreModules + /roles/headless; # for devices that are of the headless type - provides no GUI
  graphical = coreModules + /roles/graphical; # for devices that are of the graphical type - provides a GUI
  workstation = coreModules + /roles/workstation; # for devices that are of workstation type - any device that is for daily use
  server = coreModules + /roles/server; # for devices that are of the server type - provides online services
  laptop = coreModules + /roles/laptop; # for devices that are of the laptop type - provides power optimizations

  # extra modules - optional but likely critical to a successful build
  sharedModules = extraModules + /shared; # the path where shared modules reside

  # home-manager #
  homesDir = ../homes; # home-manager configurations for hosts that need home-manager
  homes = [hm homesDir]; # combine hm flake input and the home module to be imported together

  # a list of shared modules that ALL systems need
  shared = [
    common # the "sane" default shared across systems
    options # provide options for defined modules across the system
    sharedModules # consume my flake's own nixosModules
    agenix # age encryption for secrets
    profiles # profiles program overrides per-host
  ];
in {
  # My main desktop boasting a RX 6700XT and a Ryzen 5 3600x
  # fully free from nvidia
  # fuck nvidia - Linus "the linux" Torvalds
  enyo = mkNixosSystem {
    inherit withSystem;
    hostname = "enyo";
    system = "x86_64-linux";
    modules =
      [
        ./enyo
        graphical
        workstation
      ]
      ++ concatLists [shared homes];
    specialArgs = {inherit lib;};
  };

  # HP Pavillion from 2016
  # superseded by epimetheus
  prometheus = mkNixosSystem {
    inherit withSystem;
    hostname = "prometheus";
    system = "x86_64-linux";
    modules =
      [
        ./prometheus
        graphical
        workstation
        laptop
      ]
      ++ concatLists [shared homes];
    specialArgs = {inherit lib;};
  };

  # Identical twin host for Prometheus
  # provides full disk encryption
  # with passkey/USB authentication
  epimetheus = mkNixosSystem {
    inherit withSystem;
    hostname = "epimetheus";
    system = "x86_64-linux";
    modules =
      [
        ./epimetheus
        graphical
        workstation
        laptop
      ]
      ++ concatLists [shared homes];
    specialArgs = {inherit lib;};
  };

  # HP Pavillion laptop from 2023
  # equipped a Ryzen 7 7730U
  # usually acts as my portable workstation
  # similar to epimetheus, has full disk
  # encryption with ephemeral root using impermanence
  hermes = mkNixosSystem {
    inherit withSystem;
    hostname = "hermes";
    system = "x86_64-linux";
    modules =
      [
        ./hermes
        graphical
        workstation
        laptop
      ]
      ++ concatLists [shared homes];
    specialArgs = {inherit lib;};
  };

  # Hetzner VPS to replace my previous server machines
  # hosts some of my infrastructure
  helios = mkNixosSystem {
    inherit withSystem;
    hostname = "helios";
    system = "x86_64-linux";
    modules =
      [
        ./helios
        server
        headless
      ]
      ++ concatLists [shared homes];
    specialArgs = {inherit lib;};
  };

  # Lenovo Ideapad from 2014
  # Hybrid device
  # acts as a portable server and a "workstation"
  icarus = mkNixosSystem {
    inherit withSystem;
    hostname = "icarus";
    system = "x86_64-linux";
    modules =
      [
        ./icarus
        graphical
        workstation
        laptop
        server
      ]
      ++ concatLists [shared homes];
    specialArgs = {inherit lib;};
  };

  # Raspberry Pi 400
  # My Pi400 homelab
  # used mostly for testing networking/cloud services
  atlas = mkNixosSystem {
    inherit withSystem;
    hostname = "atlas";
    system = "aarch64-linux";
    modules =
      [
        ./atlas
        server
        headless

        # get raspbery pi 4 modules from nixos-hardware
        hw.raspberry-pi-4
      ]
      ++ shared;
    specialArgs = {inherit lib;};
  };

  # Self-made live recovery environment that overrides or/and configures certain default programs
  # provides tools and fixes the keymaps for my keyboard
  gaea = mkNixosIso {
    hostname = "gaea";
    system = "x86_64-linux";
    modules = [
      ./gaea
      iso
      headless
    ];
    specialArgs = {inherit lib;};
  };

  # An air-gapped NixOS live media to deal with
  # sensitive tooling (e.g. Yubikey, GPG, etc.)
  # isolated from all networking
  erebus = mkNixosIso {
    inherit withSystem;
    hostname = "erebus";
    system = "x86_64-linux";
    modules = [
      ./erebus
      iso
    ];
    specialArgs = {inherit lib;};
  };

  # Pretty beefy VM running on my dedicated server
  # is mostly for testing, but can run services at will
  leto = mkNixosSystem {
    inherit withSystem;
    hostname = "leto";
    system = "x86_64-linux";
    modules =
      [
        ./leto
        server
        headless
      ]
      ++ concatLists [shared homes];
    specialArgs = {inherit lib;};
  };

  # Twin virtual machine hosts
  # Artemis is x86_64-linux
  artemis = mkNixosSystem {
    inherit withSystem;
    hostname = "artemis";
    system = "x86_64-linux";
    modules =
      [
        ./artemis
        server
        headless
      ]
      ++ shared;
    specialArgs = {inherit lib;};
  };

  # Apollon is also x86_64-linux
  # but is for testing server-specific services
  apollon = mkNixosSystem {
    inherit withSystem;
    hostname = "apollon";
    system = "aarch64-linux";
    modules =
      [
        ./apollon
        server
        headless
      ]
      ++ shared;
    specialArgs = {inherit lib;};
  };
}
