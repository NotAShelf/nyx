{pkgs}: {
  type = "app";
  program = pkgs.writeShellApplication {
    name = "check-store-errors";
    text = ''
      while nix flake check --no-build |& grep "is not valid" > /tmp/invalid; do
      	path=$(awk -F\' '{print $2}' < /tmp/invalid)
      	echo "Repairing $path"
      	sudo nix-store --repair-path "$path" >/dev/null
      done
    '';
  };
}
