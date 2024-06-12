{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
in {
  options.modules.device = {
    # bluetooth is an insecure protocol if left unchedked, so while this defaults to true
    # but the bluetooth.enable option does and should not.
    hasBluetooth = mkOption {
      type = bool;
      default = true;
      description = "Whether or not the system has bluetooth support";
    };

    hasSound = mkOption {
      type = bool;
      default = true;
      description = "Whether the system has sound support (usually true except for servers)";
    };

    hasTPM = mkOption {
      type = bool;
      default = false;
      description = "Whether the system has tpm support";
    };
  };
}
