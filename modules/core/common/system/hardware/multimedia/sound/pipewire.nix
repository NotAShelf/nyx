{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) isx86Linux;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optionals;
  inherit (lib.generators) toLua;

  cfg = config.modules.system.sound;
  dev = config.modules.device;
in {
  config = mkIf (cfg.enable && dev.hasSound) {
    # if the device advertises sound enabled, and pipewire is disabled
    # for whatever reason, we may fall back to PulseAudio to ensure
    # that we still have audio. I do not like PA, but bad audio
    # is better than no audio. Though we should always use
    # PipeWire where available
    hardware.pulseaudio.enable = !config.services.pipewire.enable;

    # able to change scheduling policies, e.g. to SCHED_RR
    # sounds server use RealtimeKit (rtkti) to acquire
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

        extraConfig.pipewire."99-lowlatency" = {
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

        wireplumber = {
          enable = true;
          configPackages = let
            # generate "matches" section of the rules
            matches = toLua {
              multiline = false; # looks better while inline
              indent = false;
            } [[["node.name" "matches" "alsa_output.*"]]]; # nested lists are to produce `{{{ }}}` in the output

            # generate "apply_properties" section of the rules
            apply_properties = toLua {} {
              "audio.format" = "S32LE";
              "audio.rate" = rate * 2;
              "api.alsa.period-size" = 2;
            };
          in
            [
              (pkgs.writeTextDir "share/lowlatency.lua.d/99-alsa-lowlatency.lua" ''
                alsa_monitor.rules = {
                  {
                    matches = ${matches};
                    apply_properties = ${apply_properties};
                  }
                }
              '')
            ]
            ++ optionals dev.hasBluetooth [
              (pkgs.writeTextDir "share/bluetooth.lua.d/51-bluez-config.lua" ''
                bluez_monitor.properties = {
                  ["bluez5.enable-sbc-xq"] = true,
                  ["bluez5.enable-msbc"] = true,
                  ["bluez5.enable-hw-volume"] = true,
                  ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
                }
              '')
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
