_: {
  networking.nftables = {
    enable = false;
    tables = {
      # TODO: write a proper filter table
      #  accept: ssh, http, https and in the future, DNS
      #  block: everything else
      #  potentially allow ssh ONLY over my tailscale network
      default-filter = {
        content = "";
        family = "inet";
      };
    };
  };
}
