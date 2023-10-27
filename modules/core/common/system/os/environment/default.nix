{
  pkgs,
  lib,
  ...
}: {
  imports = [./locale.nix];
  config = {
    environment = {
      # variables that I want to set globally on all systems
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
        SYSTEMD_PAGERSECURE = "true";
        PAGER = "less -FR";
        FLAKE = "/home/notashelf/.config/nyx";
      };

      shellAliases = {
        # aliases
        rebuild = "nix-store --verify; pushd ~dotfiles ; nixos-rebuild switch --flake .#$1 --use-remote-sudo && notify-send \"Done\" ; popd";
        deploy = "nixos-rebuild switch --flake .#$1 --target-host $1 --use-remote-sudo -Lv";

        # things I do to keep my home directory clean
        wget = "wget --hsts-file='\${XDG_DATA_HOME}/wget-hsts'";
      };

      # disable all packages installed by default, so that my system doesn't have anything
      # that I myself haven't added
      defaultPackages = lib.mkForce [];

      # packages I want pre-installed on all systems
      systemPackages = with pkgs; [
        git
        curl
        wget
        pciutils
        lshw
      ];

      # enable completions for system packages
      pathsToLink = ["/share/zsh" "/share/bash-completion" "/share/nix-direnv"];

      # https://github.com/NixOS/nixpkgs/issues/72394#issuecomment-549110501
      # why??
      etc."mdadm.conf".text = ''
        MAILADDR root
      '';
    };
  };
}
