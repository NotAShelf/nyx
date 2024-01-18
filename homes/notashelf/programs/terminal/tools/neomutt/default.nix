{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.neomutt = {
      enable = true;
      vimKeys = true;
      checkStatsInterval = 60;
      sidebar = {
        enable = true;
        width = 30;
      };

      settings = {
        mark_old = "no";
        text_flowed = "yes";
        reverse_name = "yes";
        query_command = ''"khard email --parsable '%s'"'';
      };

      binds = [
        {
          action = "sidebar-toggle-visible";
          key = "\\\\";
          map = ["index" "pager"];
        }
        {
          action = "group-reply";
          key = "L";
          map = ["index" "pager"];
        }
        {
          action = "toggle-new";
          key = "B";
          map = ["index"];
        }
      ];
      macros = let
        browserpipe = "cat /dev/stdin > /tmp/muttmail.html && xdg-open /tmp/muttmail.html";
      in [
        {
          action = "<sidebar-next><sidebar-open>";
          key = "J";
          map = ["index" "pager"];
        }
        {
          action = "<sidebar-prev><sidebar-open>";
          key = "K";
          map = ["index" "pager"];
        }
        {
          action = ":set confirmappend=no\\n<save-message>+Archive<enter>:set confirmappend=yes\\n";
          key = "A";
          map = ["index" "pager"];
        }
        {
          action = "<pipe-entry>${browserpipe}<enter><exit>";
          key = "V";
          map = ["attach"];
        }
        {
          action = "<pipe-message>${pkgs.urlscan}/bin/urlscan<enter><exit>";
          key = "F";
          map = ["pager"];
        }
        {
          action = "<view-attachments><search>html<enter><pipe-entry>${browserpipe}<enter><exit>";
          key = "V";
          map = ["index" "pager"];
        }
      ];

      extraConfig = let
        # Collect all addresses and aliases
        addresses = lib.flatten (lib.mapAttrsToList (n: v: [v.address] ++ v.aliases) config.accounts.email.accounts);
        inherit (import ./muttrc.nix) config;
        inherit (import ./colors.nix) colors;
      in
        ''
          alternates "${lib.concatStringsSep "|" addresses}"
        ''
        + lib.concatStringsSep [
          config
          colors
        ];
    };

    xdg = {
      desktopEntries = {
        neomutt = {
          name = "Neomutt";
          genericName = "Email Client";
          comment = "Read and send emails";
          exec = "neomutt %U";
          icon = "mutt";
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
