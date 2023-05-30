{
  description = "My NixOS configuration with *very* questionable stability";
  # https://github.com/notashelf/nyx

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        "aarch64-linux"
        # ...
      ];

      imports = [
        ./pkgs
        {config._module.args._inputs = inputs // {inherit (inputs) self;};}
      ];

      flake = let
        # extended nixpkgs lib, contains my custom functions
        lib = import ./lib {inherit nixpkgs lib inputs;};
      in {
        # entry-point for nixos configurations
        nixosConfigurations = import ./hosts {inherit nixpkgs self lib;};

        # developer templates for easy project initialization
        templates = import ./lib/templates;

        # Recovery images for my hosts
        # build with `nix build .#images.<hostname>`
        images = import ./hosts/images.nix {inherit inputs self lib;};
      };

      perSystem = {
        config,
        inputs',
        pkgs,
        system,
        ...
      }: {
        imports = [
          {
            _module.args.pkgs = import nixpkgs {
              config.allowUnfree = true;
              config.allowUnsupportedSystem = true;
              inherit system;
            };
          }
        ];

        devShells.default = inputs'.devshell.legacyPackages.mkShell {
          packages = with pkgs; [
            nil # nix ls
            alejandra # formatter
            git # flakes require git, and so do I
            glow # markdown viewer
            statix
            deadnix
          ];
          name = "nyx";
        };

        # provide the formatter for nix fmt
        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    # I hate everything
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Nix helper
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # An upstream, feature-rich fork of the Nix package manager
    nix-super.url = "github:privatevoid-net/nix-super";

    # build against nixos unstable, more variants can be added if deemed necessary
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-pinned.url = "github:NixOS/nixpkgs/b610c60e23e0583cdc1997c54badfd32592d3d3e";

    # Automated, pre-built packages for Wayland
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Repo for hardare-specific NixOS modules
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # project shells
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Easy color integration
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Nix gaming packages
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management via agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    # my personal neovim-flake
    neovim-flake = {
      url = "github:NotAShelf/neovim-flake?ref=release/v0.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use my own arrpc-flake to provide arRPC package
    arrpc = {
      url = "github:NotAShelf/arrpc-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use my own wallpapers repository to provide various wallpapers as nix packages
    wallpkgs = {
      url = "github:NotAShelf/wallpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:SoraTenshi/helix/new-daily-driver";
      inputs = {
        rust-overlay.follows = "rust-overlay";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # anyrun program launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # spicetify for theming spotify
    spicetify = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland & Hyprland Contrib repos
    hyprland.url = "github:hyprwm/Hyprland";

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence
    impermanence.url = "github:nix-community/impermanence";

    # secure-boot on nixos
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mailserver on nixos
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.privatevoid.net"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
    ];
  };
}
