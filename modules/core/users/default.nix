{...}: {
  # we want to handle user configurations on a per-file basis - users that are not in users/<username>.nix don't get to be a real user
  imports = [
    ./notashelf.nix
    ./root.nix
  ];

  # users are not mutable outside our configurations
  # if you are on nixos, you are probably smart enough to not try and edit users
  # manually outside your configuration.nix or whatever
  users.mutableUsers = false;
}
