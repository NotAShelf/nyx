{
  osConfig,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  canary =
    (discord-canary.override {
      nss = pkgs.nss_latest;
      withOpenASAR = true;
    })
    .overrideAttrs (old: {
      libPath = old.libPath + ":${pkgs.libglvnd}/lib";
      nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.makeWrapper];

      postFixup = ''
        wrapProgram $out/opt/DiscordCanary/DiscordCanary --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
      '';
    });

  getPackage = c:
    if c == "stable"
    then pkgs.discord
    else if c == "canary"
    then canary
    else if c == "webcord"
    then pkgs.webcord-vencord
    else "";
in {
  imports = [inputs.arrpc.homeManagerModules.default];
  config = mkIf osConfig.modules.usrEnv.programs.discord.enable {
    xdg.configFile = {
      "WebCord/Themes/mocha" = let
        catppuccin-mocha = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "discord";
          rev = "c04f4bd43e571c19551e0e5da2d534408438564c";
          hash = "sha256-3uEVrR2T39Pj0puUwUPuUfXcCPoOq2lNHL8UpppTOiU=";
        };
      in {
        source = "${catppuccin-mocha}/themes/mocha.theme.css";
      };

      # share my webcord configuration across devices
      # "WebCord/config.json".source = config.lib.file.mkOutOfStoreSymlink "${self}/home/notashelf/graphical/apps/webcord/config.json";
    };

    services.arrpc.enable = true;

    home.packages = [
      (getPackage osConfig.modules.usrEnv.programs.discord.client)
    ];
  };
}
