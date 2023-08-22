_: {
  imports = [
    ./fs # filesystem support options
    ./hardware # hardware capabilities - i.e bluetooth, sound, tpm etc.
    ./media # enable multimedia
    ./boot # boot and bootloader configurations
    ./os # configurations for how the system should operate
    ./emulation # emulation via binfmt for cross-building
    ./activation # activation system for nixos-rebuild
    ./virtualization # hypervisor and virtualisation related options - docker, QEMU, waydroid etc.
  ];
}
