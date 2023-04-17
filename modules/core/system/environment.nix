{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  doas = pkgs.writeScriptBin "sudo" ''exec doas "$@"'';
in {
  environment = {
    # variables that I want to set globally on all systems
    variables = {
      EDITOR = "nvim";
      SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
    };

    # packages I want pre-installed on all systems
    systemPackages = with pkgs;
      [
        git
        curl
        wget
        pciutils
        lshw
      ]
      ++ optionals (config.security.doas.enable) [
        doas
      ];

    # enable completions for system packages
    pathsToLink = ["/share/zsh" "/share/bash-completion"];
  };
}
