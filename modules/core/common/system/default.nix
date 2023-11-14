_: {
  imports = [
    ./hardware # hardware capabilities - i.e bluetooth, sound, tpm etc.
    ./os # configurations for how the system should operate
    ./emulation # emulation via binfmt for cross-building
    ./activation # activation system for nixos-rebuild
    ./virtualization # hypervisor and virtualisation related options - docker, QEMU, waydroid etc.
    ./encryption # LUKS encryption
    ./security # anything from kernel hardening to audit daemeons
    ./nix # configuration for the nix package manager and build tool
    ./impermanence # impermanence configuration
    ./containers # hotpluggable systemd-nspawn containers
  ];
}
