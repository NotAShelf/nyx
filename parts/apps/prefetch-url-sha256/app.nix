{pkgs}: {
  type = "app";
  program = pkgs.writeScriptBin "prefetch-url-sha256" ''
    hash=$(nix-prefetch-url "$1")
    nix hash to-sri --type sha256 $hash
  '';
}
