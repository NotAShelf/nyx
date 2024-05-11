{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.lists) singleton;

  dev = config.modules.device;
in {
  # Enable the threadirqs kernel parameter to reduce audio latency
  # See <https://github.com/musnix/musnix/blob/master/modules/base.nix#L56>
  boot.kernelParams = ["threadirqs"];

  services = {
    # configure PipeWire for low latency
    # the below configuration may not fit every use case
    # and you are recommended to experiment with the values
    # in order to find the perfect configuration
    pipewire = let
      # Higher audio rate equals less latency always, unless you
      # increase your quantum.
      # To calculate node latency for your audio device take the
      # quantum size divided by your audio rate
      # => 64/96000 = 0.00066666666 * 1000 = 0.6ms # this is 0.6ms node latency
      # To check client latency use `pw-top`, take the quantum size
      # and the audio rate of the client then use `quantum / audio rate * 1000`
      # to get overall latency for the client
      quantum = toString 64;
      rate = toString 48000;
      qr = "${quantum}/${rate}"; # 64/48000
    in {
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
        pipewire = {
          "92-low-latency" = {
            "context.properties" = {
              "default.clock.rate" = rate;
              "default.clock.quantum" = quantum;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 128;
              "default.clock.allowed-rates" = [rate];

              "core.daemon" = true;
              "core.name" = "pipewire-0";
              "support.dbus" = true;
              "mem.allow-mlock" = true;
              "log.level" = 3;
              "link.max-buffers" = 16;
            };

            "context.modules" = [
              {
                name = "libpipewire-module-rt";
                flags = ["ifexists" "nofail"];
                args = {
                  "nice.level" = -15;
                  "rt.prio" = 90;
                  "rt.time.soft" = 200000;
                  "rt.time.hard" = 200000;
                };
              }
              {
                name = "libpipewire-module-protocol-pulse";
                args = {
                  "server.address" = ["unix:native"];
                  "pulse.min.quantum" = qr;
                  "pulse.min.req" = qr;
                  "pulse.min.frag" = qr;
                };
              }
            ];

            "context.objects" = [
              {
                #  A default dummy driver.
                # This handles nodes marked with the "node.always-driver" property
                # when no other driver is currently active
                factory = "spa-node-factory";
                args = {
                  "factory.name" = "support.node.driver";
                  "node.name" = "Dummy-Driver";
                  "node.group" = "pipewire.dummy";
                  "priority.driver" = 20000;
                };
              }
              {
                factory = "spa-node-factory";
                args = {
                  "factory.name" = "support.node.driver";
                  "node.name" = "Freewheel-Driver";
                  "priority.driver" = 19000;
                  "node.group" = "pipewire.freewheel";
                  "node.freewheel" = true;
                };
              }
            ];

            "stream.properties" = {
              "node.latency" = qr;
              "resample.quality" = 1;
            };
          };

          # Noise Cancelling Source for microphone:
          # <https://github.com/werman/noise-suppression-for-voice>
          "60-microphone-rnnoise" = {
            "context.modules" = [
              {
                name = "libpipewire-module-filter-chain";
                args = {
                  "node.description" = "Microphone (noise suppressed)";
                  "media.name" = "Microphone (noise suppressed)";
                  "filter.graph" = {
                    nodes = singleton {
                      type = "ladspa";
                      name = "rnnoise";
                      plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                      label = "noise_suppressor_mono";
                      control = {
                        "VAD Threshold (%)" = 85.0;
                        "VAD Grace Period (ms)" = 500;
                        "Retroactive VAD Grace (ms)" = 0;
                      };
                    };
                  };

                  "audio.rate" = 48000;
                  "audio.position" = ["FL"];
                  "capture.props" = {
                    "node.passive" = true;
                    "node.name" = "rnnoise_input";
                  };

                  "playback.props" = {
                    "media.class" = "Audio/Source";
                    "node.name" = "rnnoise_output";
                  };
                };
              }
            ];
          };
        };

        pipewire-pulse."92-low-latency" = {
          "context.modules" = [
            {
              name = "libpipewire-module-rt";
              flags = ["nofail"];
              args = {
                "nice.level" = -11;
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
            }
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                "pulse.min.req" = qr;
                "pulse.default.req" = qr;
                "pulse.max.req" = qr;
                "pulse.min.quantum" = qr;
                "pulse.max.quantum" = qr;
              };
            }
          ];

          "stream.properties" = {
            "node.latency" = qr;
            "resample.quality" = 1;
          };
        };
      };

      wireplumber = {
        enable = true;
        extraConfig = mkMerge [
          {
            # Tell wireplumber to be more verbose
            "10-log-level-debug" = {
              "context.properties"."log.level" = "D"; # output debug logs
            };

            # Default volume is by default set to 0.4
            # instead set it to 1.0
            "60-defaults" = {
              "wireplumber.settings"."device.routes.default-sink-volume" = 1.0;
            };

            "60-hdmi-lowprio" = {
              matches = singleton {
                "api.alsa.path" = "hdmi:.*";
              };

              actions.update-props = {
                "priority.session" = 100;
                "node.pause-on-idle" = true;
              };
            };

            "60-onboard-card" = {
              matches = [
                {
                  subject = "media.class";
                  comparison = "Audio/Device";
                }
                {
                  subject = "device.product.name";
                  comparison = "Starship/Matisse HD Audio Controller";
                }
              ];
            };

            # Configure each device/card/output to use the low latency configuration
            "92-low-latency" = {
              # Some applications still use the ALSA channels, so the configuration
              # for Wireplumber doesn't properly apply to them. In that case, they should
              # follow the ALSA configuration instead.
              "monitor.alsa.rules" = [
                {
                  matches = singleton {
                    # Matches all sinks.
                    "node.name" = "~alsa_output.*";
                  };

                  actions.update-props = {
                    # Give a human-readable name to the matching devices/sources/sinks.
                    "node.nick" = "ALSA Low Latency";

                    # Low latency configuration
                    "audio.rate" = rate;
                    "audio.format" = "S32LE";
                    "resample.quality" = 4;
                    "resample.disable" = false;
                    # 0 disables suspend
                    "session.suspend-timeout-seconds" = 0;
                    "api.alsa.period-size" = 2;
                    # Default: 0
                    "api.alsa.headroom" = 128;
                    # Default: 2
                    "api.alsa.period-num" = 2;
                    # generally, USB soundcards use the batch mode
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
                }
              ];
            };
          })
        ];
      };
    };
  };
}
