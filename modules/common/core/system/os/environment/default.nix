{pkgs, ...}: {
  imports = [
    ./locale.nix # locale settings
    ./display # display protocol (wayland/xorg)
  ];
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

    # packages I want pre-installed on all systems
    systemPackages = with pkgs; [
      git
      curl
      wget
      pciutils
      lshw
    ];

    # disable all packages installed by default, so that my system doesn't have anything
    # that I myself haven't added
    defaultPackages = [];

    # enable completions for system packages
    pathsToLink = ["/share/zsh" "/share/bash-completion" "/share/nix-direnv"];
  };
}
