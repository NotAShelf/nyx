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
  xdg.desktopEntries."nvf" = mkForce {
    name = "Neovim";
    type = "Application";
    mimeType = ["text/plain"];

    icon = fetchurl {
      url = "https://github.com/NotAShelf/nvf/blob/f66a879dcea156fac682943551f5f574a787bb26/.github/assets/nvf-logo-work.svg";
      sha256 = "sha256:0nn1vfca5azwdcmyzmwafqzk687gmvwl6mdgdx745r7y90315nq8";
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
