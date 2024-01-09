{
  config.modules.device = {
    type = "laptop";
    cpu.type = "intel";
    gpu.type = "hybrid-nv"; # nvidia drivers :b:roke
    monitors = ["eDP-1"];
    hasBluetooth = true;
    hasSound = true;
    hasTPM = true;
  };
}
