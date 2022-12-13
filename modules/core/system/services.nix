{pkgs, ...}: {
  services = {
    thermald.enable = true;
    acpid.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    lorri.enable = true;
    udisks2.enable = true;
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
  };
}
