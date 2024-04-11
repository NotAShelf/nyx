{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf makeBinPath optionalString;
  inherit (config) modules;

  env = modules.usrEnv;
  sys = modules.system;
  prg = sys.programs;

  programs = makeBinPath (with pkgs; [
    inputs.hyprland.packages.${stdenv.system}.default
    coreutils
    power-profiles-daemon
    systemd
    libnotify
  ]);

  startscript = pkgs.writeShellScript "gamemode-start" ''
    ${optionalString (env.desktop == "Hyprland") ''
      export PATH=$PATH:${programs}
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
      hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'
    ''}

    powerprofilesctl set performance
    notify-send -a 'Gamemode' 'Optimizations activated' -u 'low'
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    ${optionalString (env.desktop == "Hyprland") ''
      export PATH=$PATH:${programs}
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
      hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'
    ''}

    powerprofilesctl set balanced
    notify-send -a 'Gamemode' 'Optimizations deactivated' -u 'low'
  '';
in {
  config = mkIf prg.gaming.gamemode.enable {
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

    security.wrappers.gamemode = {
      owner = "root";
      group = "root";
      source = "${pkgs.gamemode}/bin/gamemoderun";
      capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    };

    # <https://www.phoronix.com/news/Fedora-39-VM-Max-Map-Count>
    # <https://github.com/pop-os/default-settings/blob/master_jammy/etc/sysctl.d/10-pop-default-settings.conf>
    boot.kernel.sysctl = {
      # default on some gaming (SteamOS) and desktop (Fedora) distributions
      # might help with gaming performance
      "vm.max_map_count" = 2147483642;
    };
  };
}
