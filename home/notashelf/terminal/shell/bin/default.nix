{
  config,
  pkgs,
  lib,
  ...
}: {
  home = {
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    file = {
      ".local/bin/updoot" = {
        # Upload and get link
        executable = true;
        text = import ./updoot.nix {inherit lib pkgs;};
      };

      ".local/bin/preview" = {
        # Preview script for fzf tab
        executable = true;
        text = import ./preview.nix {inherit lib pkgs;};
      };

      ".local/bin/show-zombie-parents" = {
        # pretty self-explanatory
        executable = true;
        text = import ./show-zombie-parents.nix {inherit lib pkgs;};
      };

      ".local/bin/tzip" = {
        # Find all latest .tmod files recursively in current directory and zip them
        # for tmodloader mods downloaded via steam workshop
        executable = true;
        text = import ./tzip.nix {inherit lib pkgs;};
      };
    };
  };
}
