{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  sys = config.modules.system;
in {
  config = mkIf (sys.virtualization.enable) {
    environment.systemPackages = with pkgs; [virt-manager docker-compose];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
          swtpm.enable = true;
        };
      };

      docker = {
        enable = true;
        enableOnBoot = false;
      };

      podman = {
        enable = true;
        #dockerCompat = true;
        enableNvidia = builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;
      };

      lxd.enable = false;
    };
  };
}
