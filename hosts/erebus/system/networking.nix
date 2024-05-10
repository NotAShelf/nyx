{
  # make sure we are air-gapped
  networking = {
    wireless.enable = false;
    dhcpcd.enable = false;
  };
}
