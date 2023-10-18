_: {
  imports = [./i3];
  services.xserver = {
    displayManager.startx.enable = true;
  };
}
