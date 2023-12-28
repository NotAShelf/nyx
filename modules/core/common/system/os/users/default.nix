{
  # we want to handle user configurations on a per-file basis
  # users that are not in users/<username>.nix don't get to be a real user
  imports = [
    ./notashelf.nix
    ./nix-builder.nix
    ./root.nix
  ];
}
