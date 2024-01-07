{
  config,
  pkgs,
  ...
}: {
  services.kmscon = {
    enable = true;
    hwRender = true;

    fonts = [
      {
        name = "OverpassMono";
        package = pkgs.overpass;
      }
    ];

    extraConfig = ''
      font-size=14
      xkb-layout=${config.services.xserver.layout}
    '';
  };
}
