{
  lib,
  pkg,
  ...
}: {
  boot = {
    plymouth = let
      pack = 1;
      theme = "lone";
    in {
      enable = true;
      #themePackages =
    };
  };
}
