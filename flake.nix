{
  description = "My NixOS configuration";
  # https://github.com/notashelf/dotfiles

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

    mkSystem = pkgs: system: hostname:
      pkgs.lib.nixosSystem {
        system = system;
        modules = [
          {networking.hostName = hostname;}
          (./. + "/hosts/${hostname}/hardware-configuration.nix")
          (./. + "/hosts/${hostname}/system.nix")
          ./system/common.nix
          inputs.hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            # this does NOT go inside the home-manager section
            # you fucking moron
            # - past raf to future raf
            nixpkgs.overlays = [
              inputs.nixpkgs-wayland.overlay
              (import ./overlays)
            ];
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {inherit inputs;};
              users.notashelf = ./. + "/hosts/${hostname}/user.nix";
            };
          }
        ];
        specialArgs = {inherit inputs;};
      };
  in {
    nixosConfigurations = {
      # host                               # arch         # hostname
      prometheus = mkSystem inputs.nixpkgs "x86_64-linux" "prometheus";
      icarus = mkSystem inputs.nixpkgs "x86_64-linux" "icarus";
    };

    packages.${system} = {
      catppuccin-folders = pkgs.callPackage ./pkgs/catppuccin-folders.nix {};
      catppuccin-gtk = pkgs.callPackage ./pkgs/catppuccin-gtk.nix {};
      catppuccin-cursors = pkgs.callPackage ./pkgs/catppuccin-cursors.nix {};
      rofi-calc-wayland = pkgs.callPackage ./pkgs/rofi-calc-wayland.nix {};
      rofi-emoji-wayland = pkgs.callPackage ./pkgs/rofi-emoji-wayland.nix {};
      battop = pkgs.callPackage ./pkgs/rust-battop.nix {};
      cloneit = pkgs.callPackage ./pkgs/cloneit.nix {};
    };

    devShells.${system}.default = pkgs.mkShell {packages = [pkgs.alejandra];};
    formatter.${system} = pkgs.alejandra;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    webcord.url = "github:fufexan/webcord-flake";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Utility Functions
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };
}
