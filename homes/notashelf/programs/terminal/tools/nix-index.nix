{inputs, ...}: {
  imports = [inputs.nix-index-db.hmModules.nix-index];

  config = {
    home.sessionVariables = {
      # auto-run programs using nix-index-database
      NIX_AUTO_RUN = "1";
    };

    programs = {
      nix-index-database.comma.enable = true;

      # `command-not-found` relies on nix-channel.
      # Enable and use `nix-index` instead.
      command-not-found.enable = false;
      nix-index = {
        enable = true;

        # link nix-inde database to ~/.cache/nix-index
        symlinkToCacheHome = true;
      };
    };
  };
}
