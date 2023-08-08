{
  config,
  lib,
  ...
}:
with lib; {
  imports = [
    ./impermanence.nix
    ./networking.nix
    ./security.nix
    ./boot.nix
    ./activation.nix
  ];
  config = {
    warnings =
      if config.modules.system.fs == []
      then [
        ''          You have not added any filesystems to be supported by your system. You may end up with an unbootable system!
                      Consider setting `config.modules.system.fs` in your configuration
        ''
      ]
      else [];
  };

  options.modules.system = {
    # the default user (not users) you plan to use on a specific device
    # this will dictate the initial home-manager settings if home-manager is
    # enabled in usrEnv
    # TODO: allow for a list of usernames, map them individually to homes/<username>
    username = mkOption {
      type = types.str;
      description = "The username of the non-root superuser for your system";
    };

    # no actual use yet, do not use
    hostname = mkOption {
      type = types.str;
    };

    fs = mkOption {
      type = types.listOf types.string;
      default = ["vfat" "ext4" "btrfs"]; # TODO: zfs, ntfs
      description = mdDoc ''
        A list of filesystems available supported by the system
        it will enable services based on what strings are found in the list.

        It would be a good idea to keep vfat and ext4 so you can mount USBs.
      '';
    };

    # should we enable emulation for additional architechtures?
    # enabling this option will make it so that you can build for, e.g.
    # aarch64 on x86_&4 and vice verse - not recommended on weaker machines
    emulation = {
      enable = mkEnableOption "cpu architecture emulation via qemu";
    };

    # should sound related programs and audio-dependent programs be enabled
    sound = {
      enable = mkEnableOption "sound (Pipewire)";
    };

    # should the device enable graphical programs
    video = {
      enable = mkEnableOption "video drivrs";
    };

    # should the device load bluetooth drivers and enable blueman
    bluetooth = {
      enable = mkEnableOption "bluetooth module and drivers";
    };

    # should the device enable printing module and try to load common printer modules
    # you might need to add more drivers to the printing module for your printer to work
    printing = {
      enable = mkEnableOption "printing";
      "3d".enable = mkEnableOption "3D printing suite";
    };

    # should virtualization (docker, qemu, podman etc.) be enabled
    virtualization = {
      enable = mkEnableOption "virtualization";
      docker = {enable = mkEnableOption "docker";};
      podman = {enable = mkEnableOption "podman";};
      qemu = {enable = mkEnableOption "qemu";};
      waydroid = {enable = mkEnableOption "waydroid";};
    };
  };
}
