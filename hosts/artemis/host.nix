{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  config = {
    modules.device.type = "vm";
    zramSwap.enable = lib.mkForce false;

    boot = {
      initrd = {
        supportedFilesystems = ["bcachefs"]; # make bcachefs work
        availableKernelModules = ["bcache"];
      };

      kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
    };

    environment = {
      shells = with pkgs; [bash zsh];

      systemPackages = with pkgs; [
        bcachefs-tools
        starship # having starship here means pkgs.startship will be stored during build and not during promptInit
      ];
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      promptInit = ''
        eval "$(${lib.getExe pkgs.starship} init zsh)"
      '';
    };

    users.users."user" = {
      description = "Testing user with sudo access and no password";
      isNormalUser = true;
      password = "";
      extraGroups = ["wheel" "networkmanager"];
      shell = pkgs.zsh;
    };

    security.sudo.wheelNeedsPassword = false;

    virtualisation = {
      memorySize = 2048;
      diskSize = 4096;
      cores = 3;
      useDefaultFilesystems = false;
      rootDevice = "/dev/vda1";

      fileSystems = {
        "/" = {
          device = "${config.virtualisation.rootDevice}:/dev/vda2";
          fsType = lib.mkForce "bcachefs";
        };
      };

      interfaces = {
        vm0 = {
          vlan = 1;
        };
      };
    };

    boot.initrd.postDeviceCommands = with pkgs; ''
      if ! test -b /dev/vda1; then
        ${parted}/bin/parted --script /dev/vda -- mklabel gpt
        ${parted}/bin/parted --script /dev/vda -- mkpart primary 1MiB 25%
        ${parted}/bin/parted --script /dev/vda -- mkpart primary 25% 100%
        sync
      fi

      FSTYPE=$(blkid -o value -s TYPE /dev/vda1 || true)
      if test -z "$FSTYPE"; then
        ${bcachefs-tools}/bin/bcachefs format /dev/vda1 /dev/vda2 --replicas=2 --label=root
      fi
    '';
  };
}
