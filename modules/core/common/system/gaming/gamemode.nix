{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf makeBinPath optionalString;
  inherit (config) modules;

  env = modules.usrEnv;
  sys = modules.system;

  programs = makeBinPath (with pkgs; [
    inputs.hyprland.packages.${stdenv.system}.default
    coreutils
    power-profiles-daemon
    systemd
  ]);

  startscript = pkgs.writeShellScript "gamemode-start" ''
    ${optionalString (env.desktop == "Hyprland") ''
      export PATH=$PATH:${programs}
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
      hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'
    ''}

      powerprofilesctl set performance
      ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    ${optionalString (env.desktop == "Hyprland") ''
      export PATH=$PATH:${programs}
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
      hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'
    ''}

      powerprofilesctl set balanced
      ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'
  '';

  prg = config.modules.system.programs;
in {
  config = mkIf prg.gaming.enable {
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };

        custom = {
          start = startscript.outPath;
          end = endscript.outPath;
        };
      };
    };

    security.wrappers = {
      gamemode = {
        owner = "root";
        group = "root";
        source = "${pkgs.gamemode}/bin/gamemoderun";
        capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
      };
    };
  };
}
