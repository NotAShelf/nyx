{pkgs}: {
  type = "app";
  program = pkgs.writeShellApplication {
    name = "check-kernel-variation";
    text = ''
      booted="$(readlink -f /run/booted-system/kernel)"
      current="$(readlink -f /run/current-system/kernel)"

      booted_kernel=$(basename "$booted")
      current_kernel=$(basename "$current")

      if [[ "$booted_kernel" != "$current_kernel" ]]; then
          echo "Restart required!"
          echo "Old: $booted_kernel"
          echo "New: $current_kernel"
          exit 1
      else
          echo "System is clean..."
      fi
    '';
  };
}
