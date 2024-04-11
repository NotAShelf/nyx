{
  perSystem = {pkgs, ...}: {
    checks.default = pkgs.writeShellApplication {
      name = "check-store-errors";
      text = ''
        while nix flake check --no-build |& grep "is not valid" >/tmp/invalid; do
        	path=$(cat /tmp/invalid | awk -F\' '{print $2}')
        	echo "Repairing $path"
        	sudo nix-store --repair-path $path >/dev/null
        done
      '';
    };
  };
}
