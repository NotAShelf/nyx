{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nh.nixosModules.default];

  config = {
    nh = {
      enable = true;
      package = pkgs.nh;

      # whether to let nh run gc on the store daily
      # this is overall good for storage, but has negative
      # implications on disk health and the performance
      # of the nix daemon - which will be slowed during gc
      clean = {
        enable = true;
        dates = "daily";
      };
    };
  };
}
