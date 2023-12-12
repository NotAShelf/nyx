{
  pkgs,
  lib,
  ...
}: {
  environment = {
    # disable all packages installed by default, so that my system doesn't have anything
    # that I myself haven't added
    defaultPackages = lib.mkForce [];

    # packages I want pre-installed on all systems
    systemPackages = with pkgs; [
      git
      curl
      wget
      pciutils
      lshw
      man-pages
      rsync
    ];
  };
}
