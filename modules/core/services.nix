{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    resolved.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';

    lorri.enable = true;

    # enable and secure ssh
    openssh = {
      enable = lib.mkDefault false;
      permitRootLogin = "no";
    };
  };
}
