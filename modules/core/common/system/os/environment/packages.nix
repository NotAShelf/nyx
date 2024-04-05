{
  pkgs,
  lib,
  ...
}: {
  environment = {
    # nixos ships a bunch of packages by default under environment.defaultPackages
    # those do not add much to the system closure, but for a little added extra security
    # and in an attempt to reduce my system closure size, I would like those to be
    # removed from my packages
    defaultPackages = lib.mkForce [];

    # packages that will be shared across all users and and all systems
    # this should generally include tools used for debugging
    # or system administration
    systemPackages = with pkgs; [
      git
      curl
      wget
      pciutils
      lshw
      man-pages
      rsync
      bind.dnsutils
    ];
  };
}
