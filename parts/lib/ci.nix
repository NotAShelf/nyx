# Modified from https://github.com/nix-community/nix-github-actions
# available under the MIT license.
{lib, ...}: let
  inherit (builtins) map isList;
  inherit (lib.attrsets) attrValues mapAttrs attrNames;
  inherit (lib.lists) flatten singleton;

  githubPlatforms = {
    "x86_64-linux" = "ubuntu-22.04";
    "x86_64-darwin" = "macos-12";
  };

  # Return a GitHub Actions matrix from a package set shaped like
  # the Flake attribute packages/checks.
  mkGithubMatrix = {
    checks, # Takes an attrset shaped like { x86_64-linux = { hello = pkgs.hello; }; }
    attrPrefix ? "githubActions.checks",
    platforms ? githubPlatforms,
  }: {
    inherit checks;
    matrix = {
      include = flatten (attrValues (
        mapAttrs
        (
          system: pkgs:
            map
            (attr: {
              os = let
                targetHost = platforms.${system};
              in
                if isList targetHost
                then targetHost
                else singleton targetHost;
              attr = (
                if attrPrefix != ""
                then "${attrPrefix}.${system}.${attr}"
                else "${system}.${attr}"
              );
            })
            (attrNames pkgs)
        )
        checks
      ));
    };
  };
in {
  inherit mkGithubMatrix;
}
