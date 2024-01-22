{
  config,
  lib,
  ...
}: let
  inherit (lib) mapAttrsToList flatten concatStringsSep;
in {
  config = {
    programs.neomutt = {
      enable = true;
      vimKeys = true;
      checkStatsInterval = 60;

      # sidebar
      sidebar = {
        enable = true;
        width = 30;
        format = "%D%?F? [%F]?%* %?N?%N/?%S";
      };

      # sort default view by threads
      sort = "threads";

      # get keybinds from their respective file
      inherit (import ./binds.nix) binds;

      # get settings from their respective file
      inherit (import ./settings.nix {inherit config;}) settings;

      # get macros from their respective file
      inherit (import ./macros.nix) macros;

      extraConfig = let
        # collect all addresses and aliases from accounts.email.accounts attribute of home-manager
        accounts = mapAttrsToList (_: value: [value.address] ++ value.aliases) config.accounts.email.accounts;
        addresses = flatten accounts;
      in ''
        # add collected accounts to neomutt config
        alternates "${concatStringsSep "|" addresses}"

        # mark anything marked by SpamAssassin as probably spam
        spam "X-Spam-Score: ([0-9\\.]+).*" "SA: %1"

        # only show the basic mail headers
        ignore *
        unignore From To Cc Bcc Date Subject

        # show headers in the following order
        unhdr_order *
        hdr_order From: To: Cc: Bcc: Date: Subject:

      '';
    };

    xdg = {
      desktopEntries = {
        neomutt = {
          name = "Neomutt";
          genericName = "Email Client";
          comment = "Read and send emails";
          exec = "neomutt %U";
          icon = "neomutt";
          terminal = true;
          categories = ["Network" "Email" "ConsoleOnly"];
          type = "Application";
          mimeType = ["x-scheme-handler/mailto"];
        };
      };
      mimeApps.defaultApplications = {
        "x-scheme-handler/mailto" = "neomutt.desktop";
      };
    };
  };
}
