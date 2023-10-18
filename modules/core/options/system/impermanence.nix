{lib, ...}: let
  inherit (lib) mkEnableOption mkOption mdDoc;
in {
  options.modules.system.impermanence = {
    root = {
      enable = mkEnableOption (mdDoc ''
        Enable the Impermanence module for persisting important state directories.
        By default, Impermanence will not touch user's $HOME, which is not ephemeral unlike root.
      '');

      extraFiles = mkOption {
        default = [];
        example = [
          "/etc/nix/id_rsa"
        ];
        description = mdDoc ''
          Additional files in the root to link to persistent storage.
        '';
      };

      extraDirectories = mkOption {
        default = [];
        example = [
          "/var/lib/libvirt"
        ];
        description = mdDoc ''
          Additional directories in the root to link to persistent
          storage.
        '';
      };
    };

    home = {
      enable = mkEnableOption (mdDoc ''
        Enable the Impermanence module for persisting important state directories.
        This option will also make user's home ephemeral, on top of the root subvolume
      '');

      home = {
        mountDotfiles = lib.mkOption {
          default = true;
          description = ''
            Whether the repository with my configuration flake should be bound to a location in $HOME after a rebuild
            It will symlink ''${SELF} to ~/.config/nyx where I usually put my configuration files
          '';
        };

        extraFiles = lib.mkOption {
          default = [];
          example = [
            ".gnupg/pubring.kbx"
            ".gnupg/sshcontrol"
            ".gnupg/trustdb.gpg"
            ".gnupg/random_seed"
          ];
          description = ''
            Additional files in the home directory to link to persistent
            storage.
          '';
        };

        extraDirectories = lib.mkOption {
          default = [];
          example = [
            ".config/gsconnect"
          ];
          description = ''
            Additional directories in the home directory to link to
            persistent storage.
          '';
        };
      };
    };
  };
}
