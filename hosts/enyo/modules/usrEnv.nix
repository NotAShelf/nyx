{
  config.modules.usrEnv = {
    desktop = "Hyprland";
    desktops."i3".enable = true;
    useHomeManager = true;

    programs = {
      dolphin.enable = true;
      media.mpv.enable = true;

      launchers = {
        anyrun.enable = true;
        tofi.enable = true;
      };

      git.signingKey = "0xAF26552424E53993 ";

      screenlock.swaylock.enable = true;
    };
  };
}
