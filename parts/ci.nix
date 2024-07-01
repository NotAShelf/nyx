{self, ...}: let
  inherit (self) lib;
  inherit (lib) mkGithubMatrix;
  inherit (lib.attrsets) getAttrs filterAttrs;
in {
  flake.githubActions = mkGithubMatrix {
    checks = getAttrs ["x86_64-linux"] (
      filterAttrs (name: _: name != "present") self.packages
    );
  };
}
