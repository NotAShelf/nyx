{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.dev;
in {
  # enable opportunistic TCP encryption
  # this is NOT a pancea, however, if the receiver supports encryption and the attacker is passive
  # privacy will be more plausible (but not guaranteed, unlike what the option docs suggest)
  networking.tcpcrypt.enable = dev.type != "server";

  users = mkIf config.networking.tcpcrypt.enable {
    groups.tcpcryptd = {};
    users.tcpcryptd = {
      group = "tcpcryptd";
      isSystemUser = true;
    };
  };
}
