_: let
  # check if the host platform is linux and x86
  # (isx86Linux pkgs) -> true
  isx86Linux = pkgs: with pkgs.stdenv; hostPlatform.isLinux && hostPlatform.isx86;
in {
  inherit isx86Linux;
}
