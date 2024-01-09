{lib, ...}: let
  inherit (lib) mkOption mkEnableOption types;
in {
  options.modules.device = {
    type = mkOption {
      type = types.enum ["laptop" "desktop" "server" "hybrid" "lite" "vm"];
      default = "";
      description = ''
        The type/purpose of the device that will be used within the rest of the configuration.
          - laptop: portable devices with batter optimizations
          - desktop: stationary devices configured for maximum performance
          - server: server and infrastructure
          - hybrid: provide both desktop and server functionality
          - lite: a lite device, such as a raspberry pi
          - vm: a virtual machine
      '';
    };

    # the type of cpu your system has - vm and regular cpus currently do not differ
    # as I do not work with vms, but they have been added for forward-compatibility
    # TODO: make this a list - apparently more than one cpu on a device is still doable
    cpu = {
      type = mkOption {
        type = with types; nullOr (enum ["pi" "intel" "vm-intel" "amd" "vm-amd"]);
        default = null;
        description = ''
          The manifaturer/type of the primary system CPU.

          Determines which ucode services will be enabled and provides additional kernel packages
        '';
      };

      amd = {
        pstate.enable = mkEnableOption "AMD P-State Driver";
        zenpower = {
          enable = mkEnableOption "AMD Zenpower Driver";
          args = mkOption {
            type = types.str;
            default = "-p 0 -v 3C -f A0"; # Pstate 0, 1.175 voltage, 4000 clock speed
            description = ''
              The percentage of the maximum clock speed that the CPU will be limited to.

              This is useful for reducing power consumption and heat generation on laptops
              and desktops
            '';
          };
        };
      };
    };

    gpu = {
      type = mkOption {
        type = with types; nullOr (enum ["pi" "amd" "intel" "nvidia" "hybrid-nv" "hybrid-amd"]);
        default = null;
        description = ''
          The manifaturer/type of the primary system GPU. Allows the correct GPU
          drivers to be loaded, potentially optimizing video output performance
        '';
      };
    };

    monitors = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        A list of monitors connected to the system.

        This does not affect any drivers and such, it is only necessary for
        declaring things like monitors in window manager configurations.
        It is not necessary to declare this, but wallpaper and workspace
        configurations will be affected by the monitors list

        ::: {.tip}
          Monitors should be listed from left to right in the order they are placed
          assuming the leftmost (first element) is the primary one. This is not a
          solution to the possibility of a monitor being placed above or below another
          but it currently works.
        :::
      '';
    };
  };
}
