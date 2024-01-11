{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types literalExpression;

  cfg = config.modules.system.containers;
in {
  options.modules.system.containers = {
    enable = mkEnableOption "systemd-nspawn containers";

    availableContainers = mkOption {
      type = with types; listOf str;
      default = ["alpha" "beta" "gamma"];
      readOnly = true;
      internal = true;
      description = ''
        Containers that are made available to the host system, and can freely be enabled using
        the {option}`enabledContainers` option.

        Do keep in mind that nspawn-containers not yet provide host isolation, and elevated privileges
        inside the container can be used to escape the container and gain access to the host system.

        Only enable containers that you know are properly sandboxed.
      '';
    };

    enabledContainers = mkOption {
      type = with types; listOf (enum cfg.availableContainers);
      default = [];
      example = literalExpression ''["alpha" "beta"]'';
      description = ''
        A list of enabled containers selected from the list of available containers.

        Enabling a container may not always mean it will start automatically, and must
        done so with care.

        Container Specialization:
          - alpha: Sandboxed playground for testing software, networking and builds.
          - beta: Minimal container for running an ephemeral PostgreSQL database.
      '';
    };
  };
}
