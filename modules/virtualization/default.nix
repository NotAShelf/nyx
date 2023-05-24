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
    environment.systemPackages = with pkgs;
      mkIf (sys.qemu.enable) [
        virt-manager
        virt-viewer
      ];

    virtualisation = mkIf (sys.qemu.enable) {
      kvmgt.enable = true;
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
          swtpm.enable = true;
        };
      };

      podman = mkIf (sys.docker.enable) {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;

        enableNvidia = builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;

        autoPrune = {
          enable = true;
          flags = ["--all"];
        };
      };

      lxd.enable = false;
    };
  };
}
