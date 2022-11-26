{
  description = "My NixOS configuration";
 
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Utility Functions
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    # Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "emacs-overlay";
    };

    # agenix replacement
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  in {
    nixosConfigurations = import ./hosts inputs;

    # sd card image for raspberry pi (Atlas host)
    # build with `nix build .#images.atlas`
    images = {
      atlas =
        (self.nixosConfigurations.atlas.extendModules {
          modules = ["${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];
        })
        .config
        .system
        .build
        .sdImage;
    };
    packages.${system} = {
      # Catppuccin Theme Packages
      catppuccin-folders = pkgs.callPackage ./pkgs/catppuccin-folders.nix {};
      catppuccin-gtk = pkgs.callPackage ./pkgs/catppuccin-gtk.nix {};
      catppuccin-cursors = pkgs.callPackage ./pkgs/catppuccin-cursors.nix {};

      # Rofi Plugins
      rofi-calc-wayland = pkgs.callPackage ./pkgs/rofi-calc-wayland.nix {};
      rofi-emoji-wayland = pkgs.callPackage ./pkgs/rofi-emoji-wayland.nix {};

      # Misc
      cloneit = pkgs.callPackage ./pkgs/cloneit.nix {};
      battop = pkgs.callPackage ./pkgs/rust-battop.nix {};
      nicksfetch = pkgs.callPackage ./pkgs/nicksfetch.nix {};
    };

    devShells.${system}.default = pkgs.mkShell {packages = [pkgs.alejandra];};
    formatter.${system} = pkgs.alejandra;
  };
}
