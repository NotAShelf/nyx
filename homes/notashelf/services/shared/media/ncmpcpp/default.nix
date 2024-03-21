{
  config,
  pkgs,
  ...
}: {
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {visualizerSupport = true;};
    mpdMusicDir = config.services.mpd.musicDirectory;
  };
}
