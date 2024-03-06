{pkgs, ...}: {
  # the thunar file manager
  # we enable thunar here and add plugins instead of in systemPackages
  # it is enabled unconditionally as a relatively lightweight fallback
  # option for my system file manager. I still use dolphin most of the time
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      # packages necessery for thunar thumbnails
      xfce.tumbler
      libgsf # odf files
      ffmpegthumbnailer
      ark # GUI archiver for thunar archive plugin
    ];
  };
}
