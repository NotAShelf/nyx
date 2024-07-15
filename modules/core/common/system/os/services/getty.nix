{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
  revision =
    if config.system.configurationRevision != null
    then " @ " + config.system.configurationRevision # this is already a string, no need to toString it
    else "";
in {
  services.getty = {
    greetingLine = "<<< Welcome to ${config.meta.hostname}${revision} >>>";
    helpLine = mkForce "";
  };
}
