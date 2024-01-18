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
    {
      title = "Hacker News Daily";
      url = "https://www.daemonology.net/hn-daily/index.rss";
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

    # Unsorted
    {url = "https://nitter.net/GergelyOrosz/rss";}
    {url = "https://feeds.feedburner.com/ThePragmaticEngineer";}
    {url = "https://www.reddit.com/r/ExperiencedDevs/.rss";}
    {url = "https://news.ycombinator.com/rss";}
    {url = "https://programming.dev/feeds/local.xml?sort=Active";}
    {url = "https://programming.dev/feeds/c/functional_programming.xml?sort=Active";}
    {url = "https://programming.dev/feeds/c/linux.xml?sort=Active";}
    {url = "https://programming.dev/feeds/c/experienced_devs.xml?sort=Active";}
    {url = "https://programming.dev/feeds/c/nix.xml?sort=Active";}
    {url = "https://programming.dev/feeds/c/commandline.xml?sort=Active";}
    {url = "https://beehaw.org/feeds/c/technology.xml?sort=Active";}
    {url = "https://lobste.rs/rss";}
    {url = "https://kiszamolo.hu/feed";}
  ];
}
