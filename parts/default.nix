{inputs, ...}: {
  # Imports for constructing a final flake to be built.
  imports = [
    # Imported
    inputs.flake-parts.flakeModules.easyOverlay
    inputs.treefmt-nix.flakeModule

    # Explicitly import parts of the flake, which allows me to build the
    # "final flake" from various parts, arranged in a way that makes
    # sense to me the most. By convention, things that would usually
    # go to flake.nix should have its own file in the `flake/` directory.
    ./apps # apps provided by the flake
    ./checks # checks that are performed on `nix flake check`
    ./lib # extended library on top of `nixpkgs.lib`
    ./modules # nixos and home-manager modules provided by this flake
    ./pkgs # packages exposed by the flake
    ./pre-commit # pre-commit hooks, performed before each commit inside the devShell
    ./templates # flake templates

    ./args.nix # args that are passed to the flake, moved away from the main file
    ./ci.nix # GitHub actions matrices generated via Nix
    ./deployments.nix # deploy-rs configurations for active hosts
    ./fmt.nix # various formatter configurations for this flake
    ./iso-images.nix # local installation media
    ./shell.nix # devShells exposed by the flake
  ];
}
