{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };

    vim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        tabular
        vim-airline
        vim-beancount
        vim-nix
        vim-surround
      ];

      settings.undofile = true;
      extraConfig = builtins.readfile ./.vimrc;
    };
  };
}
