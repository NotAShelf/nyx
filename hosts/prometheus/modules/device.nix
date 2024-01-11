{
  config.modules.device = {
    type = "laptop";
    cpu.type = "intel";
    gpu.type = "intel"; # nvidia drivers :b:roke
    monitors = ["eDP-1" "HDMI-A-1"];
    hasBluetooth = true;
    hasSound = true;
    hasTPM = true;
  };
}
