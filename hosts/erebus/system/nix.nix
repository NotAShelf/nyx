{
  # Secure defaults
  nixpkgs.config = {allowBroken = false;}; # false breaks zfs kernel - but we don't care about zfs
}
