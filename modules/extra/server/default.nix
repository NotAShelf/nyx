_: {
  imports = [
    ./programs
    ./services
    ./users.nix
  ];

  config = {
    # we don't need any x libs on a server
    environment.noXlibs = true;
  };
}
