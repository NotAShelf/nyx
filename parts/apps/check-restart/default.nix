{pkgs}: {
  type = "app";
  program = pkgs.writeShellApplication {
    name = "nix-flake-check";
    text = ''
      booted="$(readlink -f /run/booted-system/kernel)"
      current="$(readlink -f /run/current-system/kernel)"

      booted_kernel=$(basename "$booted")
      current_kernel=$(basename "$current")

      if [[ "$booted_kernel" != "$current_kernel" ]]; then
          echo "Restart required!"
          echo "old: $booted_kernel"
          echo "new: $current_kernel"
          exit 1
      else
          echo "system is clean.."
      fi
    '';
  };
}
