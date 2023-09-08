{
  description = "My NixOS configuration with *very* questionable stability";
  # https://github.com/notashelf/nyx

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        "aarch64-linux"
        # and more if they can be supported ...
      ];

      imports = [
        # add self back to inputs, I depend on inputs.self at least once
        {config._module.args._inputs = inputs // {inherit (inputs) self;};}

        # parts and modules from inputs
        inputs.flake-parts.flakeModules.easyOverlay
        inputs.treefmt-nix.flakeModule

        # parts of the flake
        ./parts/pkgs # packages exposed by the flake
        ./parts/args # args that are passsed to the flake, moved away from the main file
        ./parts/templates # exposed templates for nodejs, rust and C++ # TODO: bash, python and go
      ];

      flake = let
        # extended nixpkgs library, contains my custom functions
        # such as system builders
        lib = import ./lib {inherit nixpkgs inputs;};
      in {
        # TODO: I still don't have a darwin machine to test my configs on - avoid pushing
        # darwinConfigurations = {};

        # entry-point for nixos configurations
        nixosConfigurations = import ./hosts {inherit nixpkgs self lib withSystem;};

        # set of modules exposed by my flake to be consumed by others
        # those can be imported by adding this flake as an input and then importing the nixosModules.<moduleName>
        # i.e imports = [ inputs.nyx.nixosModules.steam-compat ]; or modules = [ inputs.nyx.nixosModules.steam-compat ];
        nixosModules = {
          # extends the steam module from nixpkgs/nixos to add a STEAM_COMPAT_TOOLS option
          steam-compat = ./modules/extra/shared/nixos/steam;

          # a module for the comma tool that wraps it with nix-index and disabled the command-not-found integration
          comma-rewrapped = ./modules/extra/shared/nixos/comma;

          # an open source implementation of wakatime server
          wakapi = ./modules/extra/shared/nixos/wakapi;

          # we do not want to provide a default module
          default = null;
        };

        homeManagerModules = {
          xplr = ./modules/extra/shared/home-manager/xplr;

          gtklock = ./modules/extra/shared/home-manager/gtklock;

          # again, we do not want to provide a default module
          default = null;
        };

        # TODO: flake checks to be invoked by nix flake check
        # checks = import ./lib/flake/checks;

        # Recovery images for my hosts
        # build with `nix build .#images.<hostname>`
        images = import ./hosts/images.nix {inherit inputs self lib;};
      };

      perSystem = {
        inputs',
        config,
        pkgs,
        ...
      }: {
        imports = [{_module.args.pkgs = config.legacyPackages;}];

        # provide the formatter for nix fmt
        formatter = pkgs.alejandra;

        devShells.default = let
          extra = import ./parts/devShell;
        in
          inputs'.devshell.legacyPackages.mkShell {
            name = "nyx";
            commands = extra.shellCommands;
            env = extra.shellEnv;
            packages = with pkgs; [
              inputs'.agenix.packages.default # provide agenix CLI within flake shell
              config.treefmt.build.wrapper # treewide formatter
              nil # nix ls
              alejandra # nix formatter
              git # flakes require git, and so do I
              glow # markdown viewer
              statix # lints and suggestions
              deadnix # clean up unused nix code
            ];
          };

        # configure treefmt
        treefmt = {
          projectRootFile = "flake.nix";

          programs = {
            alejandra.enable = true;
            deadnix.enable = false;
            shellcheck.enable = true;
            shfmt = {
              enable = true;
              # https://flake.parts/options/treefmt-nix.html#opt-perSystem.treefmt.programs.shfmt.indent_size
              # 0 causes shfmt to use tabs
              indent_size = 0;
            };
          };
        };
      };
    });

  inputs = {
    # until a new release is out and in nixpkgs:
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # build against nixos unstable, more versions with pinned branches can be added if deemed necessary
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs with a pinned commit
    # nixpkgs-pinned.url = "github:NixOS/nixpkgs/b610c60e23e0583cdc1997c54badfd32592d3d3e";

    # Automated, pre-built packages for Wayland
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Repo for hardare-specific NixOS modules
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Nix wrapper for building and testing my system
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # a tree-wide formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # feature-rich and convenient fork of the Nix package manager
    nix-super.url = "github:privatevoid-net/nix-super";

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
      url = "github:NotAShelf/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
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

    # anyrun program launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
    };

    # spicetify for theming spotify
    spicetify = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # schizophrenic firefox configuration
    schizofox = {
      url = "github:schizofox/schizofox";
      # url = "/home/notashelf/Dev/Schizofox/schizofox";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nixpak.follows = "nixpak";
      };
    };

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # Hyprland & Hyprland Contrib repos
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

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

    # nix index database
    nix-index-db = {
      url = "github:nix-community/nix-index-database";
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
      "https://notashelf.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      "notashelf.cachix.org-1:VTTBFNQWbfyLuRzgm2I7AWSDJdqAa11ytLXHBhrprZk="
    ];
  };
}
