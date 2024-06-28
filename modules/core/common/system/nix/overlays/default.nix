{
  inputs',
  config,
  pkgs,
  ...
}: {
  # Overlays are by far the most obscure and annoying feature of Nix, and if you have
  # interacted with me on a personal level before, you will find that I actively discourage
  # using them. The below section contains my personal overlays, which are used to add
  # packages to the system closure, or override existing packages. This is a last resort
  # and should be used conservatively. If possible, use override or overrideAttrs whenever
  # you are able to.
  nixpkgs.overlays = [
    (_: _: {
      nixSuper = inputs'.nix-super.packages.default;
      nixSchemas = inputs'.nixSchemas.packages.default;
    })

    (final: prev: {
      # nixos-rebuild provides its own nix package, which is not the same as the one
      # we use in the system closure - which causes an extra Nix package to be added
      # even if it's not the one we need want.
      nixos-rebuild = prev.nixos-rebuild.override {
        nix = config.nix.package;
      };

      # Patch the everliving shit out of ZSH to remove some of my personal annoyances
      # such as newuser install
      zsh = prev.zsh.overrideAttrs (old: {
        patches = [
          ./patches/0001-zsh-globquote.patch
        ];

        configureFlags = old.configureFlags or [] ++ ["--disable-site-fndir" "--without-tcsetpgrp"];
        postConfigure =
          (old.postConfigure or "")
          + ''
            sed -i -e '/^name=zsh\/newuser/d' config.modules
          '';
      });
    })
  ];
}
