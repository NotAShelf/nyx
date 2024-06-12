{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
in {
  options.modules.device = {
    # Bluetooth is an insecure protocol, especially if it has been left unchecked.
    # While this defaults to true (as most devices *do* have bluetooth), bluetooth.enable
    # should not default to true unless it's explicitly desired.
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
