{
  config,
  lib,
  ...
}: let
  inherit (lib.trivial) const;
  inherit (lib.lists) length zipListsWith;
  inherit (lib.strings) concatStringsSep escapeShellArg;

  systemNix = config.nix.package;
in {
  # Overlays are by far the most obscure and annoying feature of Nix, and if you have
  # interacted with me on a personal level before, you will find that I actively discourage
  # using them. The below section contains my personal overlays, which are used to add
  # packages to the system closure, or override existing packages. This is a last resort
  # and should be used conservatively. If possible, use override or `overrideAttrs` whenever
  # you are able to.
  nixpkgs.overlays = [
    # Some packages provide their own instances of Nix by adding `nix` to the argset
    # of a derivation. While in most cases a simple `.override` will allow you to easily
    # replace their instance of Nix, you might want to do it across the dependency tree
    # in certain cases. For example if the package you are overriding is a dependency to
    # or is called by other packages.
    (const (prev: {
      nixos-rebuild = prev.nixos-rebuild.override {
        nix = systemNix;
      };

      nix-direnv = prev.nix-direnv.override {
        nix = systemNix;
      };

      nix-index = prev.nix-index.override {
        nix = systemNix;
      };
    }))

    (const (prev: {
      lix = prev.lix.overrideAttrs (old: {
        patches = [
          ./patches/0001-nix-default-flake.patch
          ./patches/0001-nix-reject-flake-config.patch
        ];

        postPatch =
          (old.postPatch or "")
          + ''
            substituteInPlace src/libmain/shared.cc \
              --replace-fail "(Lix, like Nix)" "(Lix, Nix for lesbians)"
          '';

        postInstall =
          (old.postInstall or "")
          + ''
            ln -s $out/bin/nix $out/bin/lix
          '';
      });

      # Patch the everliving shit out of ZSH to remove some of my personal annoyances
      # such as newuser install
      zsh = prev.zsh.overrideAttrs (old: {
        patches = [
          ./patches/0002-zsh-globquote.patch

          # From:
          #  <https://github.com/fugidev/nix-config>
          ./patches/0002-zsh-completion-remote-files.patch
        ];

        configureFlags = (old.configureFlags or []) ++ ["--disable-site-fndir" "--without-tcsetpgrp"];
        postConfigure =
          (old.postConfigure or "")
          + ''
            sed -i -e '/^name=zsh\/newuser/d' config.modules
          '';
      });

      # Create an overlay for nix-output-monitor to match the inconsistent
      # and frankly ugly icons with Nerdfonts ones. they look a little larger
      # than before, but overall consistency is better in general.
      nix-output-monitor = let
        oldIcons = [
          "↑"
          "↓"
          "⏱"
          "⏵"
          "✔"
          "⏸"
          "⚠"
          "∅"
          "∑"
        ];
        newIcons = [
          "f062" # 
          "f063" # 
          "f520" # 
          "f04b" # 
          "f00c" # 
          "f04c" # 
          "f071" # 
          "f1da" # 
          "f04a0" # 󰒠
        ];
      in
        assert length oldIcons == length newIcons;
          prev.nix-output-monitor.overrideAttrs (old: {
            version = "0-unstable-2024-06-22";
            patches =
              (old.patches or [])
              ++ [
                ./patches/0003-nom-print-traces.patch
              ];

            postPatch =
              (old.postPatch or "")
              + ''
                sed -i ${escapeShellArg (
                  concatStringsSep "\n" (zipListsWith (a: b: "s/${a}/\\\\x${b}/") oldIcons newIcons)
                )} lib/NOM/Print.hs

                substituteInPlace lib/NOM/Print/Tree.hs --replace-fail '┌' '╭'
              '';
          });
    }))
  ];
}
