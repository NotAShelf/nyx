{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    environment.variables = {
      # open links with the default browser
      BROWSER = "firefox";
    };
  };
}
