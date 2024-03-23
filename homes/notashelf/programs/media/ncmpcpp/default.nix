{
  config,
  pkgs,
  ...
}: {
  imports = [./binds.nix ./settings.nix];

  config.programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {visualizerSupport = true;};
    mpdMusicDir = config.services.mpd.musicDirectory;
  };
}
