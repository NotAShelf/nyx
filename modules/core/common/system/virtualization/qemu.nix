{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system.virtualization;
in {
  config = mkIf sys.qemu.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      qemu_kvm
      qemu
    ];

    virtualisation = {
      kvmgt.enable = true;
      spiceUSBRedirection.enable = true;

      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = false;
          swtpm.enable = true;

          ovmf = {
            enable = true;
            packages = [pkgs.OVMFFull.fd];
          };
        };

        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    # this allows libvirt to use pulseaudio socket
    # which is useful for virt-manager
    hardware.pulseaudio.extraConfig = ''
      load-module module-native-protocol-unix auth-group=qemu-libvirtd socket=/tmp/pulse-socket
    '';
  };
}
