{inputs, ...}: {
  imports = [inputs.nix-index-dh.hmModules.nix-index];

  config = {
    programs.nix-index = {
      enable = true;

      # link nix-inde database to ~/.cache/nix-index
      symlinkToCacheHome = true;
    };
  };
}
