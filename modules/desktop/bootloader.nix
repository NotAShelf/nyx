{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    loader = {
      plymouth = let
        pack = 1;
        theme = "lone";
      in {
        enable = true;
        #themePackages = [(../../packages/plymouth-themes.override {inherit pack theme;})];
      };
    };
  };
}
