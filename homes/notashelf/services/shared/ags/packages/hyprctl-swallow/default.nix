{
  lib,
  buildGoModule,
  ...
}: let
  pname = "hyprctl-swallow";
  version = "v0.1.0";
in
  buildGoModule {
    inherit pname version;

    src = ./.;
    vendorHash = null;

    ldFlags = ["-w" "-s"];

    meta = {
      description = "A simple utility to toggle swallow status on Hyprland";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [NotAShelf];
      mainProgram = pname;
    };
  }
