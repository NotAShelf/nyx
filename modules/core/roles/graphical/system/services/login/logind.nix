{
  # despite being under logind, this has nothing to do with login
  # it's about power management
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "lock";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      HibernateDelaySec=3600
    '';
  };
}
