{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
  system = config.modules.system;
in {
  config = mkIf (system.printing.enable) {
    # enable cups and add some drivers for common printers
    services = {
      printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          hplip
        ];
      };

      # required for network discovery of printers
      avahi = {
        enable = true;
        # resolve .local domains for printers
        nssmdns = true;
      };
    };
  };
}
