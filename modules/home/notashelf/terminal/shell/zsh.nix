{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      share = true;
    };
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    sessionVariables = {LC_ALL = "en_US.UTF-8";};
    completionInit = ''
      autoload -U compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
      _comp_options+=(globdots)
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char
    '';
    initExtra = ''
        autoload -U url-quote-magic
        zle -N self-insert url-quote-magic
        export FZF_DEFAULT_OPTS="
        --color fg:#c6d0f5
        --color fg+:#51576d
        --color bg:#303446
        --color bg+:#303446
        --color hl:#8caaee
        --color hl+:#8caaee
        --color info:#626880
        --color prompt:#a6d189
        --color spinner:#8caaee
        --color pointer:#8caaee
        --color marker:#8caaee
        --color border:#626880
        --color header:#8caaee
        --prompt ' | '
        --pointer ''
        --layout=reverse
        --border horizontal
        --height 40
        "

      function extract() {
          if [ -z "$1" ]; then
             # display usage if no parameters given
             echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso>"
             echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
          else
             for n in "$@"
             do
               if [ -f "$n" ] ; then
                   case "''${n%,}" in
                     *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                                  tar xvf "$n"       ;;
                     *.lzma)      unlzma ./"$n"      ;;
                     *.bz2)       bunzip2 ./"$n"     ;;
                     *.cbr|*.rar) unrar x -ad ./"$n" ;;
                     *.gz)        gunzip ./"$n"      ;;
                     *.cbz|*.epub|*.zip) unzip ./"$n"   ;;
                     *.z)         uncompress ./"$n"  ;;
                     *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                                  7z x ./"$n"        ;;
                     *.xz)        unxz ./"$n"        ;;
                     *.exe)       cabextract ./"$n"  ;;
                     *.cpio)      cpio -id < ./"$n"  ;;
                     *.cba|*.ace) unace x ./"$n"     ;;
                     *.zpaq)      zpaq x ./"$n"      ;;
                     *.arc)       arc e ./"$n"       ;;
                     *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                                       extract "$n.iso" && \rm -f "$n" ;;
                     *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && \
                                       mv ./"$n.tmp" ./"''${n%.*zlib}" && rm -f "$n"   ;;
                     *)
                                  echo "extract: '$n' - unknown archive method"
                                  return 1
                                  ;;
                   esac
               else
                   echo "'$n' - file doesn't exist"
                   return 1
               fi
             done
        fi
        }

        function run() {
          nix run nixpkgs#$@
        }

        command_not_found_handler() {
          printf 'Command not found ->\033[01;32m %s\033[0m \n' "$0" >&2
          return 127
        }

        clear
    '';
    history = {
      save = 1000;
      size = 1000;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    dirHashes = {
      docs = "$HOME/Documents";
      notes = "$HOME/Cloud/Notes";
      dev = "$HOME/Dev";
      dotfiles = "$HOME/.config/nixos";
      dl = "$HOME/Downloads";
      vids = "$HOME/Media/Videos";
      music = "$HOME/Media/Music";
      screenshots = "$HOME/Pictures/Screenshots";
      media = "$HOME/Media";
    };

    shellAliases = {
      rebuild = "doas nix-store --verify; pushd ~dotfiles && doas nixos-rebuild switch --flake .# && notify-send \"Done\"&& bat cache --build; popd";
      cleanup = "doas nix-collect-garbage --delete-older-than 7d";
      bloat = "nix path-info -Sh /run/current-system";
      curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      ytmp3 = ''
        ${pkgs.yt-dlp}/bin/yt-dlp -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
      '';
      cat = "${pkgs.bat}/bin/bat --style=plain";
      grep = "${pkgs.ripgrep}/bin/rg";
      du = "${pkgs.du-dust}/bin/dust";
      ps = "${pkgs.procs}/bin/procs";
      m = "mkdir -p";
      fcd = "cd $(find -type d | fzf)";
      ls = "${pkgs.exa}/bin/exa -h --git --color=auto --group-directories-first -s extension";
      l = "ls -lF --time-style=long-iso";
      sc = "sudo systemctl";
      scu = "systemctl --user ";
      la = "${pkgs.exa}/bin/exa -lah";
      tree = "${pkgs.exa}/bin/exa --tree --icons";
      http = "${pkgs.python3}/bin/python3 -m http.server";
      burn = "pkill -9";
      diff = "diff --color=auto";
      killall = "pkill";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      "......" = "cd ../../../../../";
      v = "nvim";
      g = "git";
      sudo = "doas";
    };

    plugins = with pkgs; [
      {
        name = "zsh-nix-shell";
        src = zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        name = "zsh-vi-mode";
        src = zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fzf-tab";
        file = "fzf-tab.plugin.zsh";
        src = fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "426271fb1bbe8aa88ff4010ca4d865b4b0438d90";
          sha256 = "sha256-RXqEW+jwdul2mKX86Co6HLsb26UrYtLjT3FzmHnwfAA=";
        };
      }
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "7c390ee3bfa8069b8519582399e0a67444e6ea61";
          sha256 = "sha256-wLpgkX53wzomHMEpymvWE86EJfxlIb3S8TPy74WOBD4=";
        };
      }
      {
        name = "zsh-autopair";
        file = "zsh-autopair.plugin.zsh";
        src = fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
          sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        };
      }
    ];
  };
}
