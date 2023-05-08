{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:
with lib; let
  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "dfd6b75c3fd4487850d11e83e64721f2113d0867";
    sha256 = "sha256-rfySizeEko9YcS+SIl2u6Hulq1hPnPoe8d6lnD15lPI=";
  };

  arRPC = inputs.arrpc.packages.${pkgs.system}.default;

  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };

  device = osConfig.modules.device;
  video = osConfig.modules.system.video;
  acceptedTypes = ["desktop" "laptop" "hybrid"];
in {
  imports = [
    inputs.arrpc.homeManagerModules.default
  ];

  config = mkIf ((builtins.elem device.type acceptedTypes) && (video.enable)) {
    home = {
      packages = with pkgs; [
        webcord-vencord
      ];
    };

    xdg.configFile."WebCord/Themes/mocha" = {
      source = "${catppuccin-mocha}/themes/mocha.theme.css";
    };

    services.arrpc.enable = true;

    /*
    systemd.user.services = {
      arRPC = mkService {
        Unit.Description = "arRPC systemd service";
        Service = {
          ExecStart = "${lib.getExe arRPC}";
          Restart = "always";
        };
      };
    };
    */
  };
}
