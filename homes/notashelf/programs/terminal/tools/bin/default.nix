{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
  inherit (builtins) readFile;
in {
  home = {
    # make sure the scripts linked below in the session PATH
    # so that they can be referred to by name
    sessionPath = ["${config.home.homeDirectory}/.local/bin"];

    # link scripts to the local PATH
    file = {
      ".local/bin/preview" = {
        # Preview script for fzf tab
        source = getExe (pkgs.writeShellApplication {
          name = "preview";
          runtimeInputs = with pkgs; [fzf eza catimg];
          text = readFile ./preview/preview.sh;
        });
      };

      ".local/bin/show-zombie-parents" = {
        # Show zombie processes and their parents
        source = getExe (pkgs.writeShellApplication {
          name = "show-zombie-parents";
          runtimeInputs = with pkgs; [fzf eza catimg];
          text = readFile ./show-zombie-parents/show-zombie-parents.sh;
        });
      };

      ".local/bin/tzip" = {
        # Find all latest .tmod files recursively in current directory and zip them
        # for tmodloader mods downloaded via steam workshop
        source = getExe (pkgs.writeShellApplication {
          name = "tzip";
          runtimeInputs = with pkgs; [zip];
          text = readFile ./tzip/tzip.sh;
        });
      };

      ".local/bin/extract" = {
        # Extract the compressed file with the correct tool based on the extension
        source = getExe (pkgs.writeShellApplication {
          name = "extract";
          runtimeInputs = with pkgs; [zip unzip gnutar p7zip];
          text = readFile ./extract/extract.sh;
        });
      };

      ".local/bin/compilec" = {
        # Interactively find and compile C++ programs
        source = getExe (pkgs.writeShellApplication {
          name = "compilec";
          runtimeInputs = with pkgs; [skim coreutils gcc];
          text = readFile ./compilec/compilec.sh;
        });
      };

      ".local/bin/fs-diff" = {
        # Show diff of two directories
        source = getExe (pkgs.writeShellApplication {
          name = "fs-diff";
          runtimeInputs = with pkgs; [coreutils gnused btrfs-progs];
          text = readFile ./fs-diff/fs-diff.sh;
        });
      };

      ".local/bin/purge-direnv" = {
        # Purge all direnv links
        source = getExe (pkgs.writeShellApplication {
          name = "purge-direnv";
          runtimeInputs = with pkgs; [direnv];
          text = readFile ./purge-direnv/purge-direnv.sh;
        });
      };

      ".local/bin/git-peek" = {
        # Quickly clone a git repo in a temporary place and open it in $EDITOR
        # Inspired by https://github.com/Jarred-Sumner/git-peek
        source = getExe (pkgs.writeShellApplication {
          name = "git-peek";
          runtimeInputs = with pkgs; [git];
          text = readFile ./git-peek/git-peek.sh;
        });
      };

      ".local/bin/addr" = {
        # Get external IP address
        source = getExe (pkgs.writeShellApplication {
          name = "addr";
          runtimeInputs = with pkgs; [curl];
          text = ''
            #!${pkgs.stdenv.shell}
            exec curl "$@" icanhazip.com
          '';
        });
      };

      ".local/bin/rm-gpucache" = {
        # Remove GPU cache
        source = getExe (pkgs.writeShellApplication {
          name = "rm-gpucache";
          runtimeInputs = with pkgs; [coreutils];
          text = ''
            #!${pkgs.stdenv.shell}
            exec rm -rf ~/.nv
          '';
        });
      };
    };
  };
}
