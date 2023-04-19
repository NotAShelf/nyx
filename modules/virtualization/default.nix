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
