{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  sys = config.modules.system.virtualization;
in {
  config = mkIf (sys.enable) {
    environment.systemPackages = with pkgs; [
      virt-manager
      docker-compose
    ];

    virtualisation = mkIf (sys.qemu.enable) {
      kvmgt.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
          swtpm.enable = true;
          package = pkgs.qemu_kvm;
        };
      };

      docker = mkIf (sys.docker.enable) {
        enable = true;
        enableOnBoot = false;
      };

      podman = mkIf (sys.podman.enable) {
        enable = true;
        #dockerCompat = true;
        enableNvidia = builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;
      };

      lxd.enable = false;
    };
  };
}
