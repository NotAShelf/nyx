{
  description = "My NixOS configuration with *very* questionable stability";
  # https://github.com/notashelf/dotfiles

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = import ./lib {inherit nixpkgs lib;};
    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        tarball-ttl = 0;
      };
    };
  in {
    nixosConfigurations = import ./hosts {inherit nixpkgs self lib;};

    # Recovery images for my hosts
    # build with `nix build .#images.<hostname>`
    images = {
      # TODO: import images from a different file to de-clutter flake.nix
      atlas =
        (self.nixosConfigurations.atlas.extendModules {
          modules = ["${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];
        })
        .config
        .system
        .build
        .sdImage;
      # TODO: build on non-nixos for better reproducibility
      prometheus =
        (self.nixosConfigurations.prometheus.extendModules {
          modules = ["${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"];
          # modules = ["${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"]; ????
        })
        .config
        .system
        .build
        .isoImage;
      icarus =
        (self.nixosConfigurations.icarus.extendModules {
          modules = ["${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"];
        })
        .config
        .system
        .build
        .isoImage;
      gaea =
        (self.nixosConfigurations.gaea)
        .config
        .system
        .build
        .isoImage;
    };

    packages.${system} = import ./pkgs {inherit pkgs;};

    devShells.${system}.default = pkgs.mkShell {
      name = "nixos";
      packages = with pkgs; [
        nil
        yaml-language-server
        alejandra
        git
        glow
        statix
        deadnix
      ];
    };

    formatter.${system} = pkgs.alejandra;

    checks.${system} = import ./lib/checks {inherit pkgs inputs;};
  };

  inputs = {
    # Nix itself, the package manager
    nix = {
      url = "github:NixOS/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs variants for different channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    #nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    # impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Fortunateteller2k's nixpkgs collection
    #nixpkgs-f2k = {
    #  url = "github:fortuneteller2k/nixpkgs-f2k";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # Automated, pre-built packages for Wayland
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository
    # TODO: make a toggleable NUR module that uses an overlay
    #nur.url = "github:nix-community/NUR";

    # Nix Developer Environments
    # devshell.url = "github:numtide/devshell";

    # Repo for hardare-specific NixOS modules
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Easy color integration
    nix-colors.url = "github:misterio77/nix-colors";

    # Nix gaming packages
    nix-gaming.url = "github:fufexan/nix-gaming";

    # Secrets management via ragenix, an agenix replacement
    ragenix.url = "github:yaxitech/ragenix";

    # Hyprland & Hyprland Contrib repos
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
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

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Webcord, maybe works better than discord client?
    webcord.url = "github:fufexan/webcord-flake";

    # Spicetify
    /*
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs"
    };
    */

    helix.url = "github:SoraTenshi/helix/experimental-22.12";

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };
}
