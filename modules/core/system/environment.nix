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
      (writeScriptBin "sudo" ''exec doas "$@"'')
    ];
  };
}
