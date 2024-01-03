{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
in {
  # https://wiki.archlinux.org/title/Systemd/Journal#Persistent_journals
  # limit systemd journal size
  # journals get big really fasti and on desktops they are not audited often
  # on servers, however, they are important for both security and stability
  # thus, persisting them as is remains a good idea
  services.journald.extraConfig = mkIf (dev.type != "server") ''
    SystemMaxUse=100M
    RuntimeMaxUse=50M
    SystemMaxFileSize=50M
  '';
}
