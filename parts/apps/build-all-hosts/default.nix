{pkgs}: {
  type = "app";
  program =
    pkgs.writers.writePython3Bin "build-all-hosts" {
      flakeIgnore = ["E501"];
    } ''
      import subprocess
      import json

      command = [
          "nix",
          "flake",
          "show",
          "--all-systems",
          "--json"
      ]

      output = subprocess.run(
          command,
          capture_output=True,
          text=True
      )

      data = json.loads(output.stdout)
      configurations = data.get("nixosConfigurations", {}).keys()

      for configuration in configurations:
          subprocess.run(["${pkgs.nixos-rebuild}/bin/nixos-rebuild", "build", "--flake", f".#{configuration}"])
    '';
}
