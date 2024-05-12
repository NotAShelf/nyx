{
  services.pipewire.wireplumber = {
    extraConfig = {
      # Tell wireplumber to be more verbose
      "10-log-level-debug" = {
        "context.properties"."log.level" = "D"; # output debug logs
      };

      # Default volume is by default set to 0.4
      # instead set it to 1.0
      "10-default-volume" = {
        "wireplumber.settings"."device.routes.default-sink-volume" = 1.0;
      };
    };
  };
}
