{
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
    # Computerphile
    {
      title = "Computerphile";
      url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC9-y-6csu5WGm29I7JiwpnA";
      tags = ["tech" "youtube"];
    }
    # Security news
    {
      title = "Krebson Security";
      url = "https://krebsonsecurity.com/feed/";
      tags = ["tech" "security"];
    }
  ];
}
