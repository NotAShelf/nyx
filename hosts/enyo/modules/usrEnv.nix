{
  config.modules.usrEnv = {
    desktop = "Hyprland";
    desktops."i3".enable = true;
    useHomeManager = true;
    launchers = {
      anyrun.enable = true;
      tofi.enable = true;
    };

    screenlock.swaylock.enable = true;
  };
}
