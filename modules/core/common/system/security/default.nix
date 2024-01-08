{
  # SEE: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
  # this makes our system more secure
  # do note that it might break some stuff, e.g. webcam
  imports = [
    ./auditd.nix # auditd
    ./clamav.nix # clamav antivirus
    ./kernel.nix # kernel hardening
    ./pam.nix # pam configuration
    ./polkit.nix # polkit configuration
    ./selinux.nix # selinux support + kernel patches
    ./sudo.nix # sudo rules and configuration
    ./virtualization.nix # hypervisor hardening
    ./usbguard.nix # usbguard
  ];
}
