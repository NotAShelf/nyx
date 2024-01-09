{pkgs, ...}: {
  nix = {
    settings.trusted-users = ["admin"];
    package = pkgs.nixUnstable;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };
}
