self: {
  imports = [
    ./locale.nix
    ./environment.nix
    ./security.nix
    ./services.nix
    ./programs.nix
  ];

  # compress half of the ram to use as swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Systemd OOMd
  # Fedora enables these options by default. See the 10-oomd-* files here:
  # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
  systemd.oomd = {
    enableRootSlice = true;
    enableUserServices = true;
  };

  # https://www.tweag.io/blog/2020-07-31-nixos-flakes/
  system.configurationRevision =
    if self ? rev
    then self.rev
    else throw "Refusing to build from a dirty Git tree!";
}
