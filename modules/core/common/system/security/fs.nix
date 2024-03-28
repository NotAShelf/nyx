{
  # Makes files that are not in or symlinked to /nix/store non-executable
  # as such random services cannot arbitrarily execute code that they have installed
  # without my knowledge. this makes it impossible for them to write and run executable
  # files outside of my nix store
  fileSystems = {
    "/var/log".options = ["noexec"];
    "/persist".options = ["noexec"];
  };
}
