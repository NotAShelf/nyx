{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.desktopEntries."Neovim" = lib.mkForce {
    name = "Neovim";
    type = "Application";
    mimeType = ["text/plain"];

    icon = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/NotAShelf/neovim-flake/main/assets/neovim-flake-logo-work.svg";
      sha256 = "19n7n9xafyak35pkn4cww0s5db2cr97yz78w5ppbcp9jvxw6yyz3";
    };

    exec = let
      wezterm = lib.getExe config.programs.wezterm.package;
      direnv = lib.getExe pkgs.direnv;
    in "${pkgs.writeShellScript "wezterm-neovim" ''
      # define target filename
      filename="$(readlink -f "$1")"

      # get the directory target file is in
      dirname="$(dirname "$filename")"

      # launch a wezterm instance with direnv and nvim
      ${wezterm} -e --cwd "$dirname" -- ${lib.getExe pkgs.zsh} -c "${direnv} exec . nvim '$filename'"
    ''} %f";
  };
}
