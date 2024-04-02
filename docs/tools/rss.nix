{
  writeShellApplication,
  pandoc,
  jaq,
  ...
}:
writeShellApplication {
  name = "generate-rss";
  runtimeInputs = [jaq];
  text = ''
    json_file="out/posts.json"
    rss_file="out/feed.xml"

    rss_title="NotAShelf/nyx"
    rss_link="https://notashelf.github.io/nyx/"

    # Description of your blog
    rss_description="NotAShelf's notes on various topics"

    # Start RSS feed XML
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
    <rss version=\"2.0\">
    <channel>
    <title>$rss_title</title>
    <link>$rss_link</link>
    <description>$rss_description</description>" >"$rss_file"

    # Parse JSON and generate RSS feed items
    jaq -r '.posts[] | select(.date != null) | "<item><title>\(.title)</title><link>\(.url)</link><description>Posted on \(.date)</description><pubDate>\(.date)</pubDate></item>"' "$json_file" >>"$rss_file"

    # Close RSS feed XML
    echo "</channel>
    </rss>" >>"$rss_file"
  '';
}
