{
  modules.usrEnv = {
    desktop = "Hyprland";
    useHomeManager = true;

    packages = {
      cli.enable = true;
      gui.enable = true;
    };

    programs = {
      media = {
        mpv.enable = true;
      };

      spotify.enable = true;

      launchers = {
        anyrun.enable = true;
        tofi.enable = true;
      };

      screenlock.swaylock.enable = true;

      git.signingKey = "0xAF26552424E53993";

      default = {
        terminal = "foot";
      };
    };
  };
}
