{
  lib,
  inputs,
  ...
}:
with lib; {
  imports = [inputs.impermanence.nixosModules.impermanence];

  /*
   TODO:
  since we roll back subvolumes using a script, it could be possible to also roll back home directory except
  important files, with the help of impermanence
  needs to be looked into
  */

  users = {
    # this option makes it that users are not mutable outside our configurations
    # if you are on nixos, you are probably smart enough to not try and edit users
    # manually outside your configuration.nix or whatever
    mutableUsers = false; # TODO: find a way to handle passwords properly

    # P.S: This option requires you to define a password file for your users
    # inside your configuration.nix - you can generate this password with
    # mkpasswd -m sha-512 > /persist/passwords/notashelf after you confirm /persist/passwords exists

    users = {
      root = {
        # passwordFile needs to be in a volume marked with `neededForBoot = true`
        passwordFile = "/persist/passwords/root";
      };
      notashelf = {
        passwordFile = "/persist/passwords/notashelf";
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/nix"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot"
      "/var/db/sudo"
      "/etc/ssh"
      "/var/lib/flatpak"
      "/var/lib/libvirt"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/pipewire"
      "/var/lib/systemd/coredump"
      "/var/cache/tailscale"
      "/var/lib/tailscale"
    ];

    files = [
      "/etc/machine-id"
      # ssh stuff
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      # other
      # TODO: optionalstring for /var/lib/${lxd, docker}
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];

  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a pristine state";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      # LUKS/TPM process
      "systemd-cryptsetup@enc.service"
      # TODO: add whatever process handles unlocking via key here
    ];
    before = [
      "sysroot.mount"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt

      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/mapper/enc /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines

      btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root
      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };
}
