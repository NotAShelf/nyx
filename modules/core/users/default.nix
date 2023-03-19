{...}: {
  # we want to handle user configurations on a per-file basis - users that are not in users/<username>.nix don't get to be a real user
  imports = [
    ./notashelf.nix
    ./root.nix
  ];

  # users are not mutable outside our configurations
  # if you are on nixos, you are probably smart enough to not try and edit users
  # manually outside your configuration.nix or whatever
  users.mutableUsers = false; # TODO: find a way to handle passwords properly

  # P.S: This option requires you to define a password for your users
  # inside your configuration.nix - you can generate this password with
  # mkpasswd -m sha-512 > /persist/passwords/notashelf after you confirm /persist/passwords exists
}
