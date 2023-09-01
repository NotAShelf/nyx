{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.modules.usrEnv.programs.libreoffice.enable {
    home.packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.en_US-large
      hunspellDicts.en_GB-large
    ];
  };
}
