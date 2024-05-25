{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe getExe';
  inherit (pkgs) eza bat ripgrep dust procs yt-dlp python3 netcat-gnu;

  dig = getExe' pkgs.dnsutils "dig";
in {
  programs.zsh.shellAliases = {
    # make sudo use aliases
    sudo = "sudo ";

    # easy netcat alias for my fiche host
    # https://github.com/solusipse/fiche
    fbin = "${getExe netcat-gnu} p.frzn.dev 9999";

    # nix specific aliases
    cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
    bloat = "nix path-info -Sh /run/current-system";
    curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    gc-check = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory|/proc)\"";
    repair = "nix-store --verify --check-contents --repair";
    run = "nix run";
    search = "nix search";
    shell = "nix shell";
    build = "nix build $@ --builders \"\"";

    # quality of life aliases
    cat = "${getExe bat} --style=plain";
    grep = "${getExe ripgrep}";
    du = "${getExe dust}";
    ps = "${getExe procs}";
    mp = "mkdir -p";
    fcd = "cd $(find -type d | fzf)";
    ls = "${getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
    l = "ls -lF --time-style=long-iso --icons";
    ytmp3 = ''
      ${getExe yt-dlp} -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
    '';

    # system aliases
    sc = "sudo systemctl";
    jc = "sudo journalctl";
    scu = "systemctl --user ";
    jcu = "journalctl --user";
    errors = "journalctl -p err..alert";
    la = "${getExe eza} -lah --tree";
    tree = "${getExe eza} --tree --icons=always";
    http = "${getExe python3} -m http.server";
    burn = "pkill -9";
    diff = "diff --color=auto";
    cpu = ''watch -n.1 "grep \"^[c]pu MHz\" /proc/cpuinfo"'';
    killall = "pkill";
    switch-yubikey = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";

    # insteaed of querying some weird and random"what is my ip" service
    # we get our public ip by querying opendns directly.
    # <https://unix.stackexchange.com/a/81699>
    canihazip = "${dig} @resolver4.opendns.com myip.opendns.com +short";
    canihazip4 = "${dig} @resolver4.opendns.com myip.opendns.com +short -4";
    canihazip6 = "${dig} @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6";

    # faster navigation
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
  };
}
