{
  description = "My NixOS configuration";
  # https://github.com/notashelf/dotfiles

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

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
    emacs-overlay.url = "github:nix-community/emacs-overlay/da2f552d133497abd434006e0cae996c0a282394";
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  in {
    nixosConfigurations = import ./hosts inputs;

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
      #proton = pkgs.callPackage ./pkgs/proton.nix {};
    };

    devShells.${system}.default = pkgs.mkShell {packages = [pkgs.alejandra];};
    formatter.${system} = pkgs.alejandra;
  };
}
