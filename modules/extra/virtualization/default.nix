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
    # TODO: # Enable CRIU alongside podman
    # programs.criu.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs;
      []
      ++ optionals (sys.qemu.enable) [
        virt-manager
        virt-viewer
      ]
      ++ optionals (sys.docker.enable) [
        podman-compose
        podman-desktop
        distrobox # TODO: add a separate option for this
      ]
      ++ optionals (sys.waydroid.enable) [
        waydroid
      ];

    virtualisation = mkIf (sys.qemu.enable) {
      kvmgt.enable = true;
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          ovmf = {
            enable = true;
            packages = [pkgs.OVMFFull.fd];
          };
          swtpm.enable = true;
        };
      };

      podman = mkIf (sys.docker.enable) {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;

        defaultNetwork.settings = {
          dns_enabled = true;
        };

        enableNvidia = builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;

        autoPrune = {
          enable = true;
          flags = ["--all"];
          dates = "weekly";
        };
      };

      lxd.enable = mkDefault config.virtualisation.waydroid.enable;
      waydroid.enable = sys.waydroid.enable;
    };
  };
}
