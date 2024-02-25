{
  imports = [
    ./containers # hotpluggable systemd-nspawn containers
    ./emulation # emulation via binfmt for cross-building
    ./encryption # LUKS encryption
    ./gaming # available games and gaming utilities such as steam and mangohud
    ./hardware # hardware capabilities - i.e bluetooth, sound, tpm etc.
    ./impermanence # impermanence configuration
    ./nix # configuration for the nix package manager and build tool
    ./os # configurations for how the system should operate
    ./security # anything from kernel hardening to audit daemeons
    ./virtualization # hypervisor and virtualisation related options - docker, QEMU, waydroid etc.
  ];
}
