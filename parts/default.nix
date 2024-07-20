{
  # Explicitly import "parts" of a flake to compose it modularly. This
  # allows me to import each part to construct the "final flake" instead
  # of declaring everything from a single, convoluted file.
  # By convention, things that would usually go to flake.nix should
  # have its own file in the `flake/` directory.
  imports = [
    ./apps # "Runnables" exposed by the flake, used with `nix run .#<appName`
    ./checks # Checks that will be built when `nix flake check is run`
    ./lib # Extensible extended library built on top of `nixpkgs.lib`
    ./modules # NixOS and Home-Manager modules provided by the flake
    ./pkgs # Per-system packages exposed by the flake
    ./pre-commit # Pre-commit hooks, to be ran before changes are committed.
    ./templates # Templates for initiating flakes with `nix flake init -t ...`

    ./args.nix # Args for the flake, consumed or propagated to parts by flake-parts
    ./ci.nix # GitHub actions matrices generated via Nix
    ./deployments.nix # deploy-rs configurations for active hosts
    ./hydra.nix # Hydra build jobs to be evaluated on each commit
    ./fmt.nix # Formatter configurations via Treefmt
    ./iso-images.nix # Build recipes for local installation media
    ./shell.nix # devShells exposed by the flake
  ];
}
