{inputs, ...}: {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
  ];

  nixpkgs.overlays = [
    inputs.neovim-flake.overlays.default
  ];

  programs.neovim-flake = {
    enable = true;
    settings = {
      vim.viAlias = true;
      vim.vimAlias = true;
    };
  };
}
