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

          verbatimConfig = ''
            namespaces = []

            # Whether libvirt should dynamically change file ownership
            dynamic_ownership = 0
          '';
        };

        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    # This allows libvirt to use pulseaudio socket
    # which is useful for virt-manager. May be just placebo, but I think
    # I have been experiencing better latency under emulation.
    hardware.pulseaudio.extraConfig = ''
      load-module module-native-protocol-unix auth-group=qemu-libvirtd socket=/tmp/pulse-socket
    '';

    # Additional kernel modules that may be needed by libvirt
    boot.kernelModules = ["vfio-pci"];

    # Trust bridge network interface(s)
    networking.firewall.trustedInterfaces = ["virbr0" "br0"];

    # For passthrough with VFI
    services.udev.extraRules = ''
      # Supporting VFIO
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';
  };
}
