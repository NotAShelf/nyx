{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.profiles = {
    workstation.enable = mkEnableOption ''
      the Desktop profile

      This profile is intended for systems that are workstations: i.e
      systems that must contain a suite of applications tailored for
      daily usage, mainly for working, studying or programming.
    '';

    gaming.enable = mkEnableOption ''
      the Gaming profile

      This profile contains basic platforms and utilities that can be
      used for gaming, such as but not limited to Steam and Lutris.
    '';
  };
}
