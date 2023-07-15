{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  programs.firejail = let
    profiles = "${getExe pkgs.firejail}/etc/firejail";
  in {
    enable = true;
    wrappedBinaries = with pkgs; {
      thunderbird = {
        executable = getExe thunderbird;
        profile = "${profiles}/thunderbird.profile";
      };
      spotify = {
        executable = getExe spotify;
        profile = "${profiles}/spotify.profile";
      };
    };
  };
}
