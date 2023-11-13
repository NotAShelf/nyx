{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (builtins.elem "alpha" config.modules.system.containers.enabledContainers) {
    systemd.services."container@alpha".after = ["container@firewall.service"];

    containers."alpha" = {
      autoStart = false;
      enableTun = true;
      ephemeral = true;
      privateNetwork = true;
      localAddress = "10.1.0.1";
      hostAddress = "10.1.0.2";
      config = _: {
        services.openssh.enable = true;

        users = {
          groups.alpha = {};
          users = {
            root.hashedPassword = "!"; # disable root login
            alpha = {
              isNormalUser = true;
              createHome = true;
              group = "alpha";
            };
          };
        };

        environment.systemPackages = with pkgs; [
          gcc
        ];

        networking.interfaces.ve-sandbox = {
          useDHCP = true;
          ipv4 = {
            addresses = [
              {
                address = "10.1.0.1";
                prefixLength = 32;
              }
            ];
            routes = [
              {
                address = "10.1.0.2";
                prefixLength = 32;
                options = {src = "10.1.0.1";};
              }
            ];
          };
        };
      };

      bindMounts = {
        "/home" = {
          hostPath = "/srv/containers/home";
          isReadOnly = true;
        };
      };
    };
  };
}
