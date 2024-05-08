{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) isx86Linux;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.lists) optionals;

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
    services.pipewire = let
      quantum = 64;
      rate = 48000;
      qr = "${toString quantum}/${toString rate}"; # 64/48000
    in {
      enable = true;

      # Additional emulation layers to enable on top of PipeWire. The backwards
      # compatibility provided by below options are impeccable and therefore
      # I choose to keep them. On a minimal system, they can (and probably should)
      # be omitted
      audio.enable = true;
      pulse.enable = true; # PulseAudio server emulation
      jack.enable = true; # JACK audio emulation
      alsa = {
        enable = true;
        support32Bit = isx86Linux pkgs; # if we're on x86 linux, we can support 32 bit
      };

      # Additional configuration files that will be placed in /etc/pipewire/pipewire.conf.d/
      # with the given file name. According to the documentation, those files take JSON therefore
      # nixpkgs' toJSON should be suitable to write the configuration files via Nix expressions.
      # P.S. Using extraConfig already converts the expression to JSON, so toJSON is not necessary
      # Also see: <https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PipeWire#quantum-ranges>
      # Useful commands:
      #  pw-top                                            # see live stats
      #  journalctl -b0 --user -u pipewire                 # see logs (spa resync in "bad")
      #  pw-metadata -n settings 0                         # see current quantums
      #  pw-metadata -n settings 0 clock.force-quantum 128 # override quantum
      #  pw-metadata -n settings 0 clock.force-quantum 0   # disable override
      extraConfig = {
        pipewire."92-low-latency" = {
          context = {
            properties.default.clock = {
              inherit quantum rate;
              max-quantum = quantum;
              min-quantum = quantum;
              allowed-rates = [rate];
            };

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
                    quantum = qr;
                    req = qr;
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
              name = "libpipewire-module-protocol-pulse";
              args.pulse = {
                min.req = qr;
                default.req = qr;
                max.req = qr;
                min.quantum = qr;
                max.quantum = qr;
              };
            }
          ];

          stream.properties = {
            node.latency = qr;
            resample.quality = 4;
          };
        };
      };

      wireplumber = {
        enable = true;
        extraConfig = mkMerge [
          {
            # Tell wireplumber to be more verbose
            "log-level-debug" = {
              "context.properties" = {
                "log.level" = "D"; # output debug logs
              };
            };

            # Configure each device/card/output to use the low latency configuration
            "92-low-latency" = {
              # Some applications still use the alsa channels, so the configuration
              # for Wireplumber doesn't properly apply to them. In that case, they should
              # follow the ALSA configuration instead.
              "monitor.alsa.rules" = [
                {
                  matches = [
                    # Matches all devices.
                    {device.name = "~alsa_card.*";}
                    # Matches all sources.
                    {node.name = "~alsa_input.*";}
                    # Matches all sinks.
                    {node.name = "~alsa_output.*";}
                  ];

                  actions.update-props = {
                    # Give a human-readable name to the matching devices/sources/sinks.
                    "node.nick" = "ALSA Low Latency";

                    # Low latency configuration
                    "audio.rate" = rate;
                    "audio.format" = "S32LE";
                    "resample.quality" = 4;
                    "resample.disable" = false;
                    "session.suspend-timeout-seconds" = 0;
                    "api.alsa.period-size" = 2;
                    # Default: 0
                    "api.alsa.headroom" = 128;
                    # Default: 2
                    "api.alsa.period-num" = 2;
                    ## generally, USB soundcards use the batch mode
                    "api.alsa.disable-batch" = false;
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
                      # Set quality to high quality instead of the default of auto
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

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  };
}
