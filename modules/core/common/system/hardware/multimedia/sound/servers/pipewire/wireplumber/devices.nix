{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.lists) singleton;

  dev = config.modules.device;
in {
  # WirePlumber is a modular session / policy manager for PipeWire
  services.pipewire.wireplumber = {
    extraConfig = mkMerge [
      {
        "11-rename-freewheel" = {
          "monitor.alsa.rules" = singleton {
            matches = singleton {
              "node.name" = "Freewheel-Driver";
            };

            actions = {
              update-props = {
                "factory.name" = "support.node.driver";
                "node.name" = "Freewheel-Driver-Custom";
                "node.description" = "Freewheel-Driver-Custom";
                "node.group" = "pipewire.freewheel";
                "node.freewheel" = true;
                "priority.driver" = 19000;
              };
            };
          };
        };

        "11-rename-dummy" = {
          "monitor.alsa.rules" = singleton {
            matches = singleton {
              "node.name" = "Dummy-Driver";
            };

            actions = {
              update-props = {
                "node.name" = "Dummy-Driver-Custom";
                "node.nick" = "Dummy-Driver-Custom";
                "node.description" = "Dummy-Driver-Custom";
                "priority.driver" = 20000;
              };
            };
          };
        };

        "60-hdmi-lowprio" = {
          "monitor.alsa.rules" = singleton {
            matches = singleton {
              "api.alsa.path" = "hdmi:.*";
            };

            actions.update-props = {
              "node.name" = "Low Priority HDMI";
              "node.nick" = "Low Priority HDMI";
              "node.description" = "Low Priority HDMI";
              "priority.session" = 100;
              "node.pause-on-idle" = true;
            };
          };
        };

        "60-onboard-card" = {
          "monitor.alsa.rules" = singleton {
            matches = [
              {"media.class" = "Audio/Device";}
              {"devie.product.name" = "Starship/Matisse HD Audio Controller";}
            ];

            actions.update-props = {
              "node.name" = "Onboard Audio";
              "node.description" = "Onboard Audio";
              "node.nick" = "Onboard Audio";
            };
          };
        };

        "70-device-VP249" = {
          "monitor.alsa.rules" = singleton {
            matches = singleton {
              "node.name" = "alsa_output.pci-0000_0b_00.1.hdmi-stereo-extra3.2";
            };

            actions.update-props = {
              "node.name" = "ASUS VP249/Display Port";
              "node.description" = "ASUS VP249/Display Port";
              "node.nick" = "ASUS VP249/Display Port";
              "priority.session" = 1000;
            };
          };
        };
      }

      (mkIf dev.hasBluetooth {
        "10-bluez" = {
          "monitor.bluez.rules" = singleton {
            matches = singleton {"device.name" = "~bluez_card.*";};
            actions = {
              update-props = {
                "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
                "bluez5.enable-msbc" = true;
                "bluez5.enable-sbc-xq" = true;
                "bluez5.enable-hw-volume" = true;

                # Set quality to high quality instead of the default of auto
                "bluez5.a2dp.ldac.quality" = "hq";
              };
            };
          };
        };
      })
    ];
  };
}
