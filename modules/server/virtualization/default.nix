{
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [virt-manager];

  virtualisation = {
    libvirtd.enable = true;

    docker = {
      enable = true;
      enableOnBoot = false;
    };

    podman = {
      enable = true;
      #dockerCompat = true;
      enableNvidia = builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;
    };
  };
}
