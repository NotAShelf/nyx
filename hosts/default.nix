{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;
  bootloader = ../modules/server/bootloader.nix;
  core = ../modules/core;
  desktop = ../modules/desktop;
  server = ../modules/server;
  nvidia = ../modules/nvidia;
  wayland = ../modules/wayland;
  hmModule = inputs.home-manager.nixosModules.home-manager;
  hw = inputs.nixos-hardware.nixosModules;

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
    modules = [
      {networking.hostName = "prometheus";}
      ./prometheus/hardware-configuration.nix
      core
      desktop
      nvidia
      wayland
      hmModule
      {inherit home-manager;}
    ];

    specialArgs = {inherit inputs;};
  };

  # Thinkpad Lenovo Yoga
  icarus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {networking.hostName = "icarus";}
      ./icarus/hardware-configuration.nix
      core
      server
      wayland
      hmModule
      {inherit home-manager;}
    ];
    specialArgs = {inherit inputs;};
  };

  # Raspberry Pi 400
  atlas = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      {networking.hostName = "atlas";}
      hw.raspberry-pi-4
      ./atlas
      core
      server
    ];
    specialArgs = {inherit inputs;};
  };
}
