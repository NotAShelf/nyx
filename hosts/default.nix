{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;
  core = ../modules/core;
  desktop = ../modules/desktop;
  server = ../modules/server;
  nvidia = ../modules/nvidia;
  wayland = ../modules/wayland;
  hmModule = inputs.home-manager.nixosModules.home-manager;
  hw = inputs.nixos-hardware.nixosModules;
  ragenix = inputs.ragenix.nixosModules.age;

  shared = [core ragenix];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.notashelf = ../modules/home;
  };
in {
  # HP Pavillion
  prometheus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "prometheus";}
        ./prometheus/hardware-configuration.nix
        desktop
        nvidia
        wayland
        hmModule
        {inherit home-manager;}
      ]
      ++ shared;

    specialArgs = {inherit inputs;};
  };

  # Thinkpad Lenovo Yoga
  icarus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "icarus";}
        ./icarus/hardware-configuration.nix
        server
        wayland
        hmModule
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # Raspberry Pi 400
  atlas = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules =
      [
        {networking.hostName = "atlas";}
        ./atlas
        hw.raspberry-pi-4
        server
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };
}
