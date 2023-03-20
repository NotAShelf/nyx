_: {
  imports = [
    # module is the skeleton that adds all nixos options for the rest of the imports
    ./module

    ./display # display protocol
    ./fs # filesystem support options
    ./hardware # hardware - i.e bluetooth, sound, tpm etc.
    ./media # enable multimedia
    ./type # device type and associated module definitions
    ./networking # tcp optimizations
  ];
}
