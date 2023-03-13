{pkgs, ...}: {
  environment = {
    # variables that I want to set globally on all systems
    variables = {
      EDITOR = "nvim";
      SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
    };

    # packages I want pre-installed on all systems
    systemPackages = with pkgs; [
      neovim
      git
      curl
      wget
      pciutils
      lshw
      (writeScriptBin "sudo" ''exec doas "$@"'')
    ];

    # enable completions for system packages
    pathsToLink = ["/share/zsh" "/share/bash-completion"];
  };
}
