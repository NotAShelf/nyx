{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = false;
    displayManager.lightdm.enable = false;

    libinput = {
      enable = true;

      # disable mouse acceleration
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
      mouse.middleEmulation = false;

      # touchpad settings
      touchpad.naturalScrolling = true;
      touchpad.tapping = true;
      touchpad.clickMethod = "clickfinger";
      touchpad.horizontalScrolling = false;
      touchpad.disableWhileTyping = true;
    };
  };
}
