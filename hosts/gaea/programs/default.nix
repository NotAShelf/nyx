{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };

    neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      configure.customRC = builtins.readFile ./.vimrc;
    };
  };
}
