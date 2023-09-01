{lib, ...}:
with lib; {
  imports = [./programs.nix ./services.nix];
  options.modules.usrEnv = {
    useHomeManager = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to use home-manager or not. Username MUST be set if this option is enabled.
      '';
    };
    desktop = mkOption {
      type = types.enum ["Hyprland" "sway" "awesome" "i3"];
      default = "Hyprland";
      description = lib.mdDoc ''
        The desktop environment to be used.
      '';
    };

    isWayland = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to enable Wayland compatibility module. This generally includes:
          - Wayland nixpkgs overlay
          - Wayland only services
          - Wayland only programs
          - Wayland compositors
          - Wayland compatible versions of packages
      '';
    };
  };
}
