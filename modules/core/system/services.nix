{pkgs, ...}: {
  services = {
    thermald.enable = true;
    acpid.enable = true;
    fstrim.enable = true;
    # firmware updater for machine hardware
    fwupd.enable = true;
    lorri.enable = true;
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
  };
}
