{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;

  # Bootloaders
  bl-common = ../modules/bootloaders/common.nix;
  bl-server = ../modules/bootloaders/server.nix;

  # shared modules
  core = ../modules/core;
  nvidia = ../modules/nvidia;
  # amd = ../modules/amd; # soon :weary:
  wayland = ../modules/wayland;
  server = ../modules/server;
  desktop = ../modules/desktop;

  # flake inputs
  hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4
  ragenix = inputs.ragenix.nixosModules.age; # secret encryption
  hmModule = inputs.home-manager.nixosModules.home-manager; # home-manager

  shared = [core ragenix];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.notashelf = ../profiles/notashelf;
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
        nvidia
        wayland
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
