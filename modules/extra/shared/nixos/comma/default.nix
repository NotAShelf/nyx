{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.comma;
in {
  options.programs.comma = with lib; {
    enable = mkEnableOption (lib.mdDoc "comma, a wrapper to run software without installing it");

    package = mkOption {
      type = types.package;
      default = pkgs.comma.override {nix-index-unwrapped = config.programs.nix-index.package;};
      defaultText = literalExpression "pkgs.comma.override { nix-index-unwrapped = config.programs.nix-index.package; }";
      description = lib.mdDoc "Package providing the `comma` tool.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    programs.command-not-found.enable = lib.mkForce false;

    programs.nix-index.enable = true;
  };
}
