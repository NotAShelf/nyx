_: {
  imports = [
    ./display # display protocol (wayland/xorg)
    ./fs # filesystem support options
    ./hardware # hardware - i.e bluetooth, sound, tpm etc.
    ./media # enable multimedia
    ./network # network configuration & tcp optimizations
    ./boot # boot and bootloader configurations
    ./os # configurations for how the system should operate
  ];
}
