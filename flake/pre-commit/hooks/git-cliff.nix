{
  perSystem = {pkgs, ...}: let
    inherit (import ../lib.nix {inherit pkgs;}) mkHook;
  in {
    pre-commit.settings = {
      hooks.git-cliff = mkHook "git-cliff" {
        enable = true;
        excludes = ["flake.lock" "r'.+\.age$'" "r'.+\.sh$'"];
        name = "Git Cliff";
        entry = "${pkgs.git-cliff}/bin/git-cliff --output CHANGELOG.md";
        language = "system";
        pass_filenames = false;
      };
    };
  };
}
