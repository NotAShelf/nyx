{
  pkgs,
  lib,
  ...
}: let
  nix-index-update = ''
    export filename="index-x86_64-$(uname | tr A-Z a-z)"
    mkdir -p ~/.cache/nix-index
    cd ~/.cache/nix-index
    # -N will only download a new version if there is an update.
    wget -Nv https://github.com/nix-community/nix-index-database/releases/latest/download/$filename
    ln -f $filename files
  '';
in {
  home.packages = [
    pkgs.nix-index
    (pkgs.writeScriptBin "nix-index-update-db" nix-index-update) # add update script to packages so that we can invoke it manually
  ];

  # set up nix-index
  systemd.user.timers.nix-index-db-update = {
    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = 0;
    };
  };

  systemd.user.services.nix-index-db-update = {
    Unit = {
      Description = "nix-index database update";
      PartOf = ["multi-user.target"];
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath [pkgs.wget pkgs.coreutils]}";
      ExecStart = "${pkgs.writeShellScript "nix-index-update-db" nix-index-update}";
    };
    Install.WantedBy = ["multi-user.target"];
  };
}
