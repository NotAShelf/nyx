{
  imports = [
    ./image # ISO image configuration
    ./system # system configuration
    ./virtualization # configure virtual machine
  ];

  config = {
    system.stateVersion = "23.11";
  };
}
