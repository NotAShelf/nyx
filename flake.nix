{
  description = "My NixOS configuration with *very* questionable stability";
  # https://github.com/notashelf/dotfiles

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    supportedSystems = [
      "x86_64-linux"
    ];

    forSystemEach = nixpkgs.lib.genAttrs supportedSystems;
    forPkgsEach = f: forSystemEach (system: f nixpkgs.legacyPackages.${system});

    lib = import ./lib {inherit nixpkgs lib inputs;};
  in {
    nixosConfigurations = import ./hosts {inherit nixpkgs self lib;};

    templates = import ./templates;

    # Recovery images for my hosts
    # build with `nix build .#images.<hostname>`
    images = import ./hosts/images.nix {inherit inputs self lib;};

    #packages.${system} = import ./pkgs {inherit pkgs;};
    packages = forPkgsEach (pkgs: import ./pkgs {inherit pkgs;});

    devShells = forPkgsEach (pkgs: {
      default = pkgs.mkShell {
        name = "nyx";
        packages = with pkgs; [
          nil
          alejandra
          git
          glow
          statix
          deadnix
        ];
      };
    });

    formatter = forPkgsEach (pkgs: pkgs.alejandra);

    checks = forPkgsEach (pkgs: import ./lib/checks {inherit pkgs inputs;});
  };

  inputs = {
    # Nix itself, the package manager
    nix = {
      url = "github:NixOS/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # build against nixos unstable, more variants can be added if deemed necessary
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # impermanence
    impermanence.url = "github:nix-community/impermanence";

    # secure-boot on nixos
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my personal neovim-flake
    neovim-flake = {
      url = "github:notashelf/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # sops-nix for atomic secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland & Hyprland Contrib repos
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Webcord, maybe works better than discord cient?
    webcord.url = "github:fufexan/webcord-flake";
    arrpc.url = "github:notashelf/arrpc-flake"; # rpc

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

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };
}
