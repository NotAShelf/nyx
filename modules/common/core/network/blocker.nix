{config, ...}: let
  device = config.module.device;
in {
  # this should block *most* junk sites
  networking = {
    stevenblack = {
      enable = device.type != "server";
      block = [
        "fakenews"
        "gambling"
        "porn"
        #"social" # blocks stuff like reddit, which I occasionally visit
      ];
    };
  };
}
