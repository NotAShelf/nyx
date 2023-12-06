{
  # the name here is arbitrary, and is used as an identifier
  # what matters is the presence of owner, rev and module
  nix-gc = {
    # https://github.com/NixOS/nixpkgs/pull/260620
    owner = "nobbz";
    rev = "10ec045f1dc82c72630c85906e1ae1d54340a7e0";
    module = "/services/misc/nix-gc.nix";
  };

  nix-20 = {
    # https://github.com/NixOS/nixpkgs/pull/271423
    owner = "hercules-ci";
    rev = "2d0f4a7ec19082248094eb04a35c93c94b1d35d5";
    module = "/config/nix.nix";
  };
}
