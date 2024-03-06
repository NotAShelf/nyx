{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  # if lvm is enabled, then tell it to issue discards
  # (this is good for SSDs and has almost no downsides on HDDs, so
  # it's a good idea to enable it unconditionally)
  environment.etc."lvm/lvm.conf".text = mkIf config.services.lvm.enable ''
    devices {
      issue_discards = 1
    }
  '';

  # discard blocks that are not in use by the filesystem, good for SSDs
  services.fstrim = {
    # we may enable this unconditionally across all systems becuase it's performance
    # impact is negligible on systems without a SSD - which means it's a no-op with
    # almost no downsides aside from the service firing once per week
    enable = true;

    # the default value, good enough for average-load systems
    interval = "weekly";
  };

  # tweak fstim service to run only when on AC power
  # and to be nice to other processes
  # (this is a good idea for any service that runs periodically)
  systemd.services.fstrim = {
    unitConfig.ConditionACPower = true;

    serviceConfig = {
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };
}
