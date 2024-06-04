{pkgs}: {
  type = "app";
  program = pkgs.writeShellApplication {
    name = "mount-local-disks";
    text = ''
      # display help message if no arguments are provided
      if [ $# -eq 0 ]; then
          echo "Usage: $0 <hostname>"
          echo "  <hostname>    The hostname to retrieve the NixOS configuration for."
          exit 1
      fi

      # set the hostname from the first argument
      hostname="$1"
      filesystemsJson=$(nix eval --json .#nixosConfigurations."$hostname".config.fileSystems)

      mount_filesystem() {
          local mount_point="$1"
          local device="$2"
          local fs_type="$3"
          local options="$4"

          echo "mounting $device at $mount_point with options $options"
          mkdir -p "$mount_point"
          mount -t "$fs_type" -o "$options" "$device" "$mount_point"
      }

      # unmount all previously mounted filesystems
      umount -R /mnt || true

      # parse and apply filesystem configurations
      echo "$filesystemsJson" | jq -c 'to_entries[]' | while read -r entry; do
          mount_point=$(echo "$entry" | jq -r '.key')
          device=$(echo "$entry" | jq -r '.value.device')
          fs_type=$(echo "$entry" | jq -r '.value.fsType')
          options=$(echo "$entry" | jq -r '.value.options // [] | join(",")')

          mount_filesystem "$mount_point" "$device" "$fs_type" "$options"
      done
    '';
  };
}
