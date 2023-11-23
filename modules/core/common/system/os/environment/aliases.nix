{pkgs, ...}: {
  environment.shellAliases = {
    # nix aliases
    rebuild = "nix-store --verify; pushd ~dotfiles ; nixos-rebuild switch --flake .#$1 --use-remote-sudo && notify-send \"Done\" ; popd";
    deploy = "nixos-rebuild switch --flake .#$1 --target-host $1 --use-remote-sudo -Lv";

    # things I do to keep my home directory clean
    wget = "wget --hsts-file='\${XDG_DATA_HOME}/wget-hsts'";

    # init a LICENSE file with my go-to gpl3 license
    "gpl" = "${pkgs.curl}/bin/curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
  };
}
