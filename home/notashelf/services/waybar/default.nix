{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  waybar_config = import ./settings.nix {inherit config lib pkgs;};
  waybar_style = import ./style.nix {inherit (config) colorscheme;};
in {
  config = {
    home.packages = with pkgs; [
      python39Packages.requests
    ];
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
        patchPhase = ''
          substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch workspace \" + name_; system(command.c_str());"
        '';
      });

      settings = waybar_config;
      style = waybar_style;
    };
  };
}
