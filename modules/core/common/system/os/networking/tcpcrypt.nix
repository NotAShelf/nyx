{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  # enable opportunistic TCP encryption
  # this is NOT a pancea, however, if the receiver supports encryption and the attacker is passive
  # privacy will be more plausible (but not guaranteed, unlike what the option docs suggest)
  # TODO: technically this is redundant as I already have some TCP security improvements, but it's a nice addition
  # I should check and see if the reason for the breakage in the service below is because of my own changes
  networking.tcpcrypt.enable = false; # FIXME: the systemd service does something wrong, investigate

  users = mkIf config.networking.tcpcrypt.enable {
    groups.tcpcryptd = {};
    users.tcpcryptd = {
      group = "tcpcryptd";
      isSystemUser = true;
    };
  };
}
