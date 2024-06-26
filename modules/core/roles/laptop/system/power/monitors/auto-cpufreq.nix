{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  # Superior power management for portable and battery powered systems. Plausible
  # but unnecessary on desktop systems.
  # See: <https://github.com/AdnanHodzic/auto-cpufreq>
  services.auto-cpufreq = {
    enable = true;
    settings = let
      MHz = x: x * 1000;
    in {
      charger = {
        # See available governors:
        #  `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`
        governor = "performance";
        # See available preferences:
        #  `cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences`
        energy_performance_preference = "performance";
        scaling_min_freq = mkDefault (MHz 1800);
        scaling_max_freq = mkDefault (MHz 3800);
        turbo = "auto";
      };

      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        scaling_min_freq = mkDefault (MHz 1200);
        scaling_max_freq = mkDefault (MHz 1800);
        turbo = "never";

        # Tresholds for battery, in percent. While those are useful to preserve battery life
        # e.g. to make your system battery live longer before you consider replacement, you
        # probably do not want those on a portable system.
        # enable_thresholds = true
        # start_threshold = 20
        # stop_threshold = 80
      };
    };
  };
}
