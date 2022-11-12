{
  services.xserver = {
    enable = false;
    #displayManager.gdm.enable = false;

    libinput = {
      enable = true;
      # disable mouse acceleration
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
      mouse.middleEmulation = false;
      # touchpad settings
      touchpad.naturalScrolling = true;
    };
  };
}
