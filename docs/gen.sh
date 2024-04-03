#!/bin/bash

workingdir="$(pwd)"
outdir="out"
posts_dir="$outdir/posts"
json_file="$outdir/posts.json"
rss_file="$outdir/feed.xml"

rss_title="NotAShelf/nyx"
rss_link="https://notashelf.github.io/nyx/"
rss_description="NotAShelf's notes on various topics"

create_directory() {
  if [ ! -d "$1" ]; then
    echo "Creating directory: $1"
    mkdir -p "$1"
  fi
}

generate_json() {
  echo "Generating JSON..."
  json='{"posts":['
  first=true
  for file in "$1"/notes/*.md; do
    filename=$(basename "$file")
    if [[ $filename != "*-todo.md" && $filename != "cheatsheet.md" && $filename != "README.md" ]]; then
      if [[ $filename =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
        # Extract date from filename
        date=$(echo "$filename" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')

        # Sanitize title
        sanitized_title=$(echo "$filename" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//; s/\.md$//; s/-/ /g; s/\b\w/\u&/g')
        if [ "$first" = true ]; then
          first=false
        else
          json="$json,"
        fi

        # Construct JSON object with title, url, date, and sanitized title
        json="$json{\"name\":\"$filename\",\"url\":\"/posts/$(basename "$file" .md).html\",\"date\":\"$date\",\"title\":\"$sanitized_title\"}"
      fi
    fi
  done
  json="$json]}"
  echo "$json" >"$2"
}

generate_index_page() {
  echo "Generating index page..."
  pandoc --from markdown --to html \
    --embed-resources --standalone \
    --template "$1"/template.html \
    --css "$1"/style.css \
    --variable="index:true" \
    "$1/notes/README.md" -o "$2/index.html"
}

generate_other_pages() {
  echo "Generating other pages..."
  for file in "$1"/notes/*.md; do
    filename=$(basename "$file")
    if [[ $filename != "*-todo.md" && $filename != "cheatsheet.md" && $filename != "README.md" ]]; then
      if [[ $filename =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
        pandoc --from markdown --to html \
          --embed-resources --standalone \
          --template "$2"/template.html \
          --css "$2"/style.css \
          "$file" -o "$3/posts/$(basename "$file" .md).html"
      else
        pandoc --from markdown --to html \
          --embed-resources --standalone \
          --template "$2"/template.html \
          --css "$2"/style.css \
          "$file" -o "$3/$(basename "$file" .md).html"
      fi
    fi
  done
}

generate_rss_feed() {
  echo "Generating RSS feed..."
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
  <rss version=\"2.0\">
  <channel>
  <title>$1</title>
  <link>$2</link>
  <description>$3</description>" >"$4"

  jq -r '.posts[] | select(.url != null) | "<item><title>\(.title)</title><link>\(.url)</link><description></description></item>"' "$5" >>"$4"

  echo "</channel>
  </rss>" >>"$4"
}

create_directory "$outdir"
create_directory "$posts_dir"
generate_json "$workingdir" "$json_file"
generate_index_page "$workingdir" "$outdir"
generate_other_pages "$workingdir" "$workingdir" "$outdir"
generate_rss_feed "$rss_title" "$rss_link" "$rss_description" "$rss_file" "$json_file"

echo "All tasks completed successfully."
