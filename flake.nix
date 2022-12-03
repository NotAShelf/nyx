{
  description = "My NixOS configuration";
  # https://dotfiles.sioodmy.dev

  inputs = {
    #"notashelf.dev".url = "github:notashelf/dıtashelf";

    # Use nixpkgs unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Secrets management via ragenix, an agenix replacement
    ragenix.url = "github:yaxitech/ragenix";

    # Hyprland & Hyprland Contrib repos
    hyprland.url = "github:hyprwm/Hyprland/";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs & Doom Emacs
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "emacs-overlay";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Webcord, maybe works better than discord client?
    webcord.url = "github:fufexan/webcord-flake";

    helix.url = "github:SoraTenshi/helix/experimental";
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };
  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  in {
    nixosConfigurations = import ./hosts inputs;

    # SD Card image for Raspberry Pi 4
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
      # Catpuccin
      catppuccin-folders = pkgs.callPackage ./pkgs/catppuccin-folders.nix {};
      catppuccin-gtk = pkgs.callPackage ./pkgs/catppuccin-gtk.nix {};
      catppuccin-cursors = pkgs.callPackage ./pkgs/catppuccin-cursors.nix {};
      # Custom rofi plugins
      rofi-calc-wayland = pkgs.callPackage ./pkgs/rofi-calc-wayland.nix {};
      rofi-emoji-wayland = pkgs.callPackage ./pkgs/rofi-emoji-wayland.nix {};
      # Everything else
      nicksfetch = pkgs.callPackage ./pkgs/nicksfetch.nix {};
      cloneit = pkgs.callPackage ./pkgs/cloneit.nix {};
    };
    devShells.${system}.default = pkgs.mkShell {packages = [pkgs.alejandra];};
    formatter.${system} = pkgs.alejandra;
  };
}
