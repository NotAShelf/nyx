{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.programs;
in {
  imports = [inputs.nix-gaming.nixosModules.steamCompat];

  config = lib.mkIf cfg.gaming.chess.enable {
    # enable steam
    programs.steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;
      # Compatibility tools to install
      # this option used to be provided by modules/shared/nixos/steam
      # I removed it while porting it to nix-gaming
      # withProtonGE = true;
      extraCompatPackages = [
        inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      ];
    };
  };
}
