{pkgs, ...}: {
  programs.nh = {
    enable = true;
    package = pkgs.nh;

    # whether to let nh run gc on the store daily
    # this is overall good for storage, but has negative
    # implications on disk health and the performance
    # of the nix daemon - which will be slowed during gc
    # NOTE: this essentially does the same thing as nix auto-gc
    # so I should decide which one to keep
    # clean = {
    #   enable = true;
    #   dates = "daily";
    # };
  };
}
