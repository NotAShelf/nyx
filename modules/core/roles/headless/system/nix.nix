{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
  inherit (lib.trivial) const;
in {
  nixpkgs.overlays = mkIf config.environment.noXlibs (singleton (const (super: {
    nginx = super.nginx.override {withImageFilter = false;};
  })));
}
