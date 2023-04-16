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
      name = "nyx";
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

    # impermanence
    impermanence.url = "github:nix-community/impermanence";

    # sops-nix for atomic secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secure-boot on nixos
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my personal neovim-flake
    neovim-flake = {
      url = "github:notashelf/neovim-flake";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # Automated, pre-built packages for Wayland
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Repo for hardare-specific NixOS modules
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Easy color integration
    nix-colors.url = "github:misterio77/nix-colors";

    # Nix gaming packages
    nix-gaming.url = "github:fufexan/nix-gaming";

    # Secrets management via ragenix, an agenix replacement
    ragenix.url = "github:yaxitech/ragenix";

    # Hyprland & Hyprland Contrib repos
    hyprland.url = "github:hyprwm/Hyprland/4bc3f9adbe7563817a9e1c6eac6f5e435f7db957";
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

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };
}
