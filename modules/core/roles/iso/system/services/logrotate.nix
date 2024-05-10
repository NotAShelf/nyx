{
  # adds an unnecessary gzip dependency to the PATH
  # you probably don't need logrotate in a headless system
  # and especially not in a live iso
  services.logrotate.enable = false;
}
