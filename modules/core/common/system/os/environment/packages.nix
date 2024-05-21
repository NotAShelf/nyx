{
  pkgs,
  lib,
  ...
}: {
  environment = {
    # NixOS ships a bunch of packages by default under environment.defaultPackages
    # and while those do not add much to the system closure, but for a little
    # added extra security and as an attempt to reduce my system closure size, I
    # remove the default packages from my system.
    # Defaults:
    #  - perl # No thank you
    #  - rsync # Already in systemPackages
    #  - strace # Never needed it
    defaultPackages = lib.mkForce [];

    # packages that will be shared across all users and all systems
    # this should generally include tools used for debugging
    # or system administration
    systemPackages = with pkgs; [
      git
      curl
      wget
      pciutils
      lshw
      rsync
      bind.dnsutils
    ];
  };
}
