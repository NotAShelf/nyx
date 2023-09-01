{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.system = {
    virtualization = {
      enable = mkEnableOption "virtualization";
      docker = {enable = mkEnableOption "docker";};
      podman = {enable = mkEnableOption "podman";};
      qemu = {enable = mkEnableOption "qemu";};
      waydroid = {enable = mkEnableOption "waydroid";};
      distrobox = {enable = mkEnableOption "distrobox";};
    };
  };
}
