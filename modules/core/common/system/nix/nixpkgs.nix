{
  inputs',
  pkgs,
  ...
}: {
  nixpkgs = {
    # global nixpkgs configuration. This is ignored if nixpkgs.pkgs is set
    # which is a case that should be avoided. Everything that is set to configure
    # nixpkgs must go here.
    # Configuration reference:
    # <https://nixos.org/manual/nixpkgs/unstable/#chap-packageconfig>
    config = {
      allowAliases = true;
      allowUnfree = true; # really a pain in the ass to deal with when disabled
      allowBroken = false;
      allowUnsupportedSystem = true;

      # default to none, add more as necessary
      permittedInsecurePackages = [];
    };

    overlays = [
      (_: _: {
        nixSuper = inputs'.nix-super.packages.default;
        nixSchemas = inputs'.nixSchemas.packages.default;
      })

      (self: super: {
        # temporary fix until upstream applies the fix we have used
        # which is just to add wrapGAppsNoGuiHook to the nativeBuildInputs
        # See: <https://github.com/NixOS/nixpkgs/pull/309315>
        networkd-dispatcher = super.networkd-dispatcher.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.wrapGAppsNoGuiHook];
        });
      })
    ];
  };
}
