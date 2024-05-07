{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) isx86Linux;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.lists) optionals;
  inherit (lib.generators) toLua;

  cfg = config.modules.system.sound;
  dev = config.modules.device;
in {
  config = mkIf (cfg.enable && dev.hasSound) {
    # Enable the threadirqs kernel parameter to reduce audio latency
    # See <https://github.com/musnix/musnix/blob/master/modules/base.nix#L56>
    boot.kernelParams = ["threadirqs"];

    # if the device advertises sound enabled, and pipewire is disabled
    # for whatever reason, we may fall back to PulseAudio to ensure
    # that we still have audio. I do not like PA, but bad audio
    # is better than no audio. Though we should always use
    # PipeWire where available
    hardware.pulseaudio.enable = !config.services.pipewire.enable;

    # able to change scheduling policies, e.g. to SCHED_RR
    # sounds server use RealtimeKit (rtkit) to acquire
    # realtime priority
    security.rtkit.enable = config.services.pipewire.enable;

    # enable pipewire and configure it for low latency
    # the below configuration may not fit every use case
    # and you are recommended to experiment with the values
    # in order to find the perfect configuration
    services = {
      pipewire = let
        quantum = 64;
        rate = 48000;
        qr = "${toString quantum}/${toString rate}";
      in {
        enable = true;

        # emulation layers
        audio.enable = true;
        pulse.enable = true; # PA server emulation
        jack.enable = true; # JACK audio emulation
        alsa = {
          enable = true;
          support32Bit = isx86Linux pkgs; # if we're on x86 linux, we can support 32 bit
        };

        extraConfig = {
          # See <https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PipeWire#quantum-ranges>
          # Useful commands:
          #  pw-top                                            # see live stats
          #  journalctl -b0 --user -u pipewire                 # see logs (spa resync in "bad")
          #  pw-metadata -n settings 0                         # see current quantums
          #  pw-metadata -n settings 0 clock.force-quantum 128 # override quantum
          #  pw-metadata -n settings 0 clock.force-quantum 0   # disable override
          pipewire."92-low-latency" = {
            context = {
              properties.default.clock.min-quantum = quantum;
              modules = [
                {
                  name = "libpipewire-module-rtkit";
                  flags = ["ifexists" "nofail"];
                  args = {
                    nice.level = -15;
                    rt = {
                      prio = 88;
                      time.soft = 200000;
                      time.hard = 200000;
                    };
                  };
                }
                {
                  name = "libpipewire-module-protocol-pulse";
                  args = {
                    server.address = ["unix:native"];
                    pulse.min = {
                      req = qr;
                      quantum = qr;
                      frag = qr;
                    };
                  };
                }
              ];

              stream.properties = {
                node.latency = qr;
                resample.quality = 1;
              };
            };
          };

          pipewire-pulse."92-low-latency" = {
            context.modules = [
              {
                name = "libpipewire-module-rtkit";
                flags = ["ifexists" "nofail"];
                args = {
                  nice.level = -15;
                  rt.prio = 88;
                  rt.time.soft = 200000;
                  rt.time.hard = 200000;
                };
              }
              {
                name = "libpipewire-module-protocol-pulse";
                args = {
                  server.address = ["unix:native"];
                  pulse = {
                    default.req = qr;
                    min.req = qr;
                    max.req = qr;
                    min.quantum = qr;
                    max.quantum = qr;
                  };
                };
              }
            ];

            stream.properties = {
              node.latency = qr;
              resample.quality = 1;
            };
          };
        };

        wireplumber = {
          enable = true;

          extraConfig = mkMerge [
            {
              # Some applications still use the alsa channels, so the configuration
              # for Wireplumber doesn't properly apply to them. In that case, they should
              # follow the ALSA configuration instead.
              main."92-low-latency" = {
                "monitor.alsa.rules" = [
                  {
                    matches = [{"device.name" = "~alsa_card.*";}];
                    actions = {
                      update-props = {
                        "audio.rate" = rate;
                        "audio.format" = "S32LE";
                        "api.alsa.period-size" = 2;
                        "resample.quality" = 4;
                        "resample.disable" = false;
                        "session.suspend-timeout-seconds" = 0;
                        # Default: 0
                        "api.alsa.headroom" = 128;
                        # Default: 2
                        "api.alsa.period-num" = 2;
                        ## generally, USB soundcards use the batch mode
                        "api.alsa.disable-batch" = false;
                      };
                    };
                  }
                ];
              };
            }

            (mkIf dev.hasBluetooth {
              bluetooth."10-bluez" = {
                "monitor.bluez.rules" = [
                  {
                    matches = [{"device.name" = "~bluez_card.*";}];
                    actions = {
                      update-props = {
                        "bluez5.roles" = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]";
                        "bluez5.a2dp.ldac.quality" = "hq";
                        "bluez5.enable-msbc" = true;
                        "bluez5.enable-sbc-xq" = true;
                        "bluez5.enable-hw-volume" = true;
                      };
                    };
                  }
                ];
              };
            })
          ];
        };
      };
    };

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  };
}
