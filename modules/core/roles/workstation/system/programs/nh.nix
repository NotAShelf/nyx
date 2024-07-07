{pkgs, ...}: {
  # This is set by `programs.nh.flake` by itself. We're just setting it here
  # so that we have a FLAKE variable set even when nh is disabled.
  environment.variables.FLAKE = "/home/notashelf/.config/nyx";

  programs.nh = {
    enable = true;
    package = pkgs.nh;

    # path to the system flake
    flake = "/home/notashelf/.config/nyx";

    # whether to let nh run gc on the store weekly
    clean = {
      enable = false; # nix-auto-gc is enabled on all systems, nh isn't.
      dates = "weekly";
    };
  };
}
