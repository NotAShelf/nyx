{
  config.modules.device = {
    type = "server";
    cpu.type = "pi";
    gpu.type = "pi";
    monitors = ["HDMI-A-1"];
    hasBluetooth = false;
    hasSound = false;
    hasTPM = false;
  };
}
