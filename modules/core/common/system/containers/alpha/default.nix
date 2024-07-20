{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
in {
  config = mkIf (elem "alpha" config.modules.system.containers.enabledContainers) {
    systemd = {
      services."container@alpha".after = ["container@firewall.service"];
      tmpfiles.rules = [
        "D /srv/containers/home 755 root root"
      ];
    };

    containers."alpha" = {
      autoStart = false;
      enableTun = true;
      ephemeral = true;
      privateNetwork = true;
      localAddress = "10.1.0.1";
      hostAddress = "10.1.0.2";
      config = _: {
        _module.args = {inherit lib;};
        nixpkgs.pkgs = pkgs;

        system.stateVersion = "23.05";

        users = {
          groups.alpha = {};
          users.alpha = {
            isNormalUser = true;
            extraGroups = ["alpha"];
            home = "/home/alpha";
            createHome = true;
            initialPassword = "alpha";
          };
        };

        environment.systemPackages = with pkgs; [
          gcc
          openjdk17_headless
          gitMinimal
        ];

        networking.interfaces.ve-alpha = {
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
          isReadOnly = false;
        };

        "/run/systemd/ask-password" = {
          hostPath = "/run/systemd/ask-password";
          isReadOnly = false;
        };
        "/run/systemd/ask-password-block" = {
          hostPath = "/run/systemd/ask-password-block";
          isReadOnly = false;
        };
      };
    };
  };
}
