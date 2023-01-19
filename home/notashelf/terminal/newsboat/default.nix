{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  mpv = "${getExe pkgs.mpv}";
  glow = "${getExe pkgs.glow}";
  pandoc = "${getExe pkgs.pandoc}";

  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs.newsboat = {
      enable = true;
      autoReload = true;
      urls = [
        # Weekly NixOS news and some other stuff
        {
          title = "NixOS Weekly";
          tags = ["news" "twitter"];
          url = "https://weekly.nixos.org/feeds/all.rss.xml";
        }
        # https://hackaday.com/blog/feed/
        {
          title = "Hacker News";
          url = "https://hnrss.org/newest";
          tags = ["tech"];
        }
        # Reddit
        {
          title = "/r/neovim";
          url = "https://www.reddit.com/r/neovim/.rss";
          tags = ["neovim" "reddit"];
        }
        {
          title = "/r/unixporn";
          url = "https://www.reddit.com/r/unixporn/.rss";
          tags = ["unix" "ricing" "style"];
        }
        # Youtube
        {
          title = "Computerphile";
          url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC9-y-6csu5WGm29I7JiwpnA";
          tags = ["tech" "youtube"];
        }
      ];
      extraConfig = ''
        download-full-page yes
        download-retries 3
        error-log /dev/null
        max-items 0
        bind-key j down
        bind-key k up
        bind-key j next articlelist
        bind-key k prev articlelist
        bind-key J next-feed articlelist
        bind-key K prev-feed articlelist
        bind-key G end
        bind-key g home
        bind-key d pagedown
        bind-key u pageup
        bind-key l open
        bind-key h quit
        bind-key a toggle-article-read
        bind-key n next-unread
        bind-key N prev-unread
        bind-key D pb-download
        bind-key U show-urls
        bind-key x pb-delete

        color listnormal black default
        color listfocus white default
        color listnormal_unread white default
        color listfocus_unread magenta default bold
        color info white black bold
        color article white default bold
        user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36"

        html-renderer "${pandoc} --from=html -t markdown_github-raw_html"
        pager "${glow} --pager --width 72"

        # macros
        macro v set browser "${mpv} %u" ; open-in-browser ; set browser "firefox %u" -- "Open video on mpv"

      '';
    };
  };
}
