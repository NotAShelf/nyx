{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) readFile;
in {
  home = {
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    file = {
      ".local/bin/preview" = {
        # Preview script for fzf tab
        source = lib.getExe (pkgs.writeShellApplication {
          name = "preview";
          runtimeInputs = with pkgs; [fzf eza catimg];
          text = readFile ./preview/preview.sh;
        });
      };

      ".local/bin/show-zombie-parents" = {
        # Show zombie processes and their parents
        source = lib.getExe (pkgs.writeShellApplication {
          name = "show-zombie-parents";
          runtimeInputs = with pkgs; [fzf eza catimg];
          text = readFile ./show-zombie-parents/show-zombie-parents.sh;
        });
      };

      ".local/bin/tzip" = {
        # Find all latest .tmod files recursively in current directory and zip them
        # for tmodloader mods downloaded via steam workshop
        source = lib.getExe (pkgs.writeShellApplication {
          name = "show-zombie-parents";
          runtimeInputs = with pkgs; [zip];
          text = readFile ./tzip/tzip.sh;
        });
      };

      ".local/bin/extract" = {
        # Extract the compressed file with the correct tool based on the extension
        source = lib.getExe (pkgs.writeShellApplication {
          name = "show-zombie-parents";
          runtimeInputs = with pkgs; [zip unzip gnutar p7zip];
          text = readFile ./extract/extract.sh;
        });
      };

      ".local/bin/compilec" = {
        # Interactively find and compile C++ programs
        source = lib.getExe (pkgs.writeShellApplication {
          name = "show-zombie-parents";
          runtimeInputs = with pkgs; [skim coreutils gcc];
          text = readFile ./compilec/compilec.sh;
        });
      };

      ".local/bin/addr" = {
        # Get external IP address
        source = lib.getExe (pkgs.writeShellApplication {
          name = "addr";
          runtimeInputs = with pkgs; [curl];
          text = ''
            #!${pkgs.stdenv.shell}
            exec curl "$@" icanhazip.com
          '';
        });
      };
    };
  };
}
