{inputs, ...}: {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage writeScriptBin;
    inherit (pkgs.writers) writePython3Bin;
  in {
    packages = {
      schizofox-startpage = callPackage ./startpage {};
      plymouth-themes = callPackage ./plymouth-themes.nix {};
      anime4k = callPackage ./anime4k.nix {};
      spotify-wrapped = callPackage ./spotify-wrapped.nix {};
      nicksfetch = callPackage ./nicksfetch.nix {};
      present = callPackage ./present.nix {};
      nixfmt-rfc = callPackage ./nixfmt-rfc.nix {inherit inputs;};

      build-all-hosts =
        writePython3Bin "build-all-hosts" {
          flakeIgnore = ["E501"];
          libraries = with pkgs.python311Packages; [tqdm];
        } ''
          import subprocess
          import json
          from tqdm import tqdm

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

          # Calculate the total number of configurations
          total_configurations = len(configurations)

          # Initialize the progress bar
          progress_bar = tqdm(total=total_configurations, desc="Building Hosts", unit="Host", ascii=True)

          for configuration in configurations:
              # Silence the output of nixos-rebuild build
              subprocess.run(["nixos-rebuild", "build", "--flake", f".#{configuration}"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
              # Update the progress bar
              progress_bar.update(1)

          # Close the progress bar
          progress_bar.close()
        '';

      prefetch-url-sha256 = writeScriptBin "prefetch-url-sha256" ''
        hash=$(nix-prefetch-url "$1")
        nix hash to-sri --type sha256 $hash
      '';
    };
  };
}
