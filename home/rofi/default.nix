{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [./style.nix];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with inputs.self.packages.${pkgs.system}; [
      rofi-calc-wayland
      rofi-emoji-wayland
    ];
    font = "Iosevka Nerd Font 13";
    extraConfig = {
      modi = "drun,filebrowser,calc,emoji";
      drun-display-format = " {name} ";
      sidebar-mode = true;
      matching = "prefix";
      scroll-method = 0;
      disable-history = true;
      show-icons = true;

      display-drun = " Run";
      display-run = " Run";
      display-filebrowser = " Files";
      display-calc = " Calculator";
      display-combi = " ";
      display-emoji = "💀 Emoji";
    };
  };
}
