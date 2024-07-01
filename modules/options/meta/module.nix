{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr bool str strMatching;

  env = config.modules.usrEnv;
in {
  options.meta = {
    hostname = mkOption {
      type = str;
      default = config.networking.hostName;
      readOnly = true;
      description = ''
        The canonical hostname of the machine.

        Is usually used to identify - i.e name machines internally
        or on the same Headscale network. This option must be declared
        in `hosts.nix` alongside host system.
      '';
    };

    system = mkOption {
      type = str;
      default = pkgs.stdenv.hostPlatform;
      readOnly = true;
      description = ''
        The architecture of the machine.
      '';
    };

    nodeAddress = mkOption {
      type = nullOr (strMatching "^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$");
      default = null;
      readOnly = true;
      description = ''
        The node address of the host on an internal network.

        This will be used to communicate between machines directly
        by using the internal network address instead of hostnames
        on, e.g., a Tailscale network.
      '';
    };

    isWayland = mkOption {
      type = bool;
      # TODO: there must be a better way to do this
      default = with env.desktops; (sway.enable || hyprland.enable);
      description = ''
        Whether to enable Wayland exclusive modules, this contains a wariety
        of packages, modules, overlays, XDG portals and so on.

        Generally includes:
          - Wayland nixpkgs overlay
          - Wayland only services
          - Wayland only programs
          - Wayland compatible versions of packages as opposed
          to the defaults
      '';
    };
  };
}
