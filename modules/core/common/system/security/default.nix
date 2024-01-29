{
  # This is the entry point of the security module.
  # This makes our system generally more secure as opposed to having nothing
  # but keep in mind that certain things (e.g. webcam) might be broken
  # as a result of the configurations provided below. Exercise caution and common sense.
  # DO NOT COPY BLINDLY
  # Also see: <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix>

  imports = [
    ./apparmor.nix # apparmor configuration and policies
    ./auditd.nix # auditd
    ./clamav.nix # clamav antivirus
    ./kernel.nix # kernel hardening
    ./pam.nix # pam configuration
    ./polkit.nix # polkit configuration
    ./selinux.nix # selinux support + kernel patches
    ./sudo.nix # sudo rules and configuration
    ./virtualization.nix # hypervisor hardening
    ./usbguard.nix # usbguard
    ./fprint.nix # fingerprint driver and login support
  ];
}
