{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;

  dev = modules.device;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf ((elem dev.type acceptedTypes) && prg.cli.enable) {
    home.packages = with pkgs; [wireguard-tools];
  };
}
