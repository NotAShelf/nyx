{pkgs, ...}: {
  imports = [./style.nix ./hardware-configuration.nix];
  config = {
    modules = {
      device = import ./device.nix;
      usrEnv =
        {
          isWayland = true;
          desktop = "Hyprland";
          useHomeManager = true;
        }
        // {programs = import ./usrEnv.nix;};

      system = import ./system.nix;
    };

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
      "/var/log".options = ["compress=zstd" "noatime"];
      "/persist".options = ["compress=zstd" "noatime"];
    };

    # fingerprint login
    # doesn't work because thanks drivers
    services.fprintd = {
      enable = false;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix;
    };

    security.pam.services = {
      login.fprintAuth = true;
      swaylock.fprintAuth = true;
    };

    console.earlySetup = true;
  };
}
