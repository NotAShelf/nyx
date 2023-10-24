{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  sys = config.modules.system.virtualization;
in {
  config = mkIf sys.enable {
    # TODO: # Enable CRIU alongside podman
    # programs.criu.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs;
      lib.concatLists [
        (optionals sys.qemu.enable [
          virt-manager
          virt-viewer
        ])
        (optionals sys.docker.enable [
          podman-compose
          podman-desktop
        ])
        (optionals sys.waydroid.enable [
          waydroid
        ])
        (optionals sys.distrobox.enable [
          distrobox
        ])
      ];

    virtualisation = {
      kvmgt.enable = true;
      spiceUSBRedirection.enable = true;

      # libvirtd configuration
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          ovmf = {
            enable = true;
            packages = [pkgs.OVMFFull.fd];
          };
          swtpm.enable = true;
        };
      };

      # podman configuration
      podman = mkIf (sys.docker.enable || sys.podman.enable) {
        enable = true;

        # make docker bakcwards compatible with docker interface
        # certain things are different, but nothing unmanagable
        dockerCompat = true;
        dockerSocket.enable = true;

        defaultNetwork.settings = {
          dns_enabled = true;
        };

        enableNvidia = builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;

        # prune images and containers periodically
        autoPrune = {
          enable = true;
          flags = ["--all"];
          dates = "weekly";
        };
      };

      lxd.enable = sys.waydroid.enable; # TODO: make this also acceept sys.lxd.enable
      waydroid.enable = sys.waydroid.enable;
    };

    # if distrobox is enabled, update it periodically
    systemd.user = mkIf sys.distrobox.enable {
      timers."distrobox-update" = {
        enable = true;
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "1h";
          OnUnitActiveSec = "1d";
          Unit = "distrobox-update.service";
        };
      };

      services."distrobox-update" = {
        enable = true;
        script = ''
          ${pkgs.distrobox}/bin/distrobox upgrade --all
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };
    };
  };
}
