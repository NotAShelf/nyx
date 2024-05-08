{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) fetchurl;
  inherit (lib.modules) mkForce;
  inherit (lib.meta) getExe;
in {
  xdg.desktopEntries."nvim" = mkForce {
    name = "Neovim";
    type = "Application";
    mimeType = ["text/plain"];

    icon = fetchurl {
      url = "https://raw.githubusercontent.com/NotAShelf/nvf/main/.github/assets/nvf-logo-work.svg";
      sha256 = "sha256:19n7n9xafyak35pkn4cww0s5db2cr97yz78w5ppbcp9jvxw6yyz3";
    };

    exec = let
      wezterm = getExe config.programs.wezterm.package;
      direnv = getExe pkgs.direnv;
    in "${pkgs.writeShellScript "wezterm-neovim" ''
      # define target filename
      filename="$(readlink -f "$1")"

      # get the directory target file is in
      dirname="$(dirname "$filename")"

      # launch a wezterm instance with direnv and nvim
      ${wezterm} -e --cwd "$dirname" -- ${getExe pkgs.zsh} -c "${direnv} exec . nvim '$filename'"
    ''} %f";
  };
}
