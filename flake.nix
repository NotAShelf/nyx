{
  description = "My NixOS configuration with questionable stability";
  # https://github.com/notashelf/dotfiles

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
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
      nixos-plymouth = pkgs.callPackage ./pkgs/nixos-plymouth.nix {};
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "nixos";
      packages = with pkgs; [
        rnix-lsp
        yaml-language-server
        alejandra
        git
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
  inputs = {
    #"notashelf.dev".url = "github:notashelf/dotfiles";

    nix = {
      url = "github:NixOS/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # default to nixpkgs unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    devshell.url = "github:numtide/devshell";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Secrets management via ragenix, an agenix replacement
    ragenix.url = "github:yaxitech/ragenix";

    # Hyprland & Hyprland Contrib repos
    hyprland.url = "github:hyprwm/Hyprland/";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
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
}
