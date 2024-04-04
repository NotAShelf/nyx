#!/usr/bin/env bash

workingdir="$(pwd)"
outdir="out"

posts_dir="$outdir/posts"
json_file="$outdir/posts.json"
rss_file="$outdir/feed.xml"

rss_title="NotAShelf/nyx"
rss_link="https://nyx.notashelf.dev"
rss_description="NotAShelf's notes on various topics"

create_directory() {
  if [ ! -d "$1" ]; then
    echo "Creating directory: $1"
    mkdir -p "$1"
  fi
}

compile_stylesheet() {
  echo "Compiling stylesheet..."
  sassc --style=compressed "$1"/templates/style.scss "$1"/out/style.css
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

        # Construct JSON object with data we may want to use
        # Note: Assuming rss_link is defined elsewhere
        json_object=$(jq -n \
          --arg name "$filename" \
          --arg url "$rss_link/posts/$(basename "$file" .md).html" \
          --arg date "$date" \
          --arg title "$sanitized_title" \
          --arg path "/posts/$(basename "$file" .md).html" \
          '{name: $name, url: $url, date: $date, title: $title, path: $path}')

        # Append JSON object to the array
        json="$json$json_object"
      fi
    fi
  done
  json="$json]}"
  # Format JSON with jq
  formatted_json=$(echo "$json" | jq .)
  echo "$formatted_json" >"$2"
}

# Index page refers to the "main" page generated
# from the README.md, which I would like to see on the front
generate_index_page() {
  echo "Generating index page..."
  pandoc --from markdown --to html \
    --standalone \
    --template "$1"/templates/template.html \
    --css "$2"/out/style.css \
    --variable="index:true" \
    --metadata title="$rss_title" \
    "$1/notes/README.md" -o "$2/index.html"
}

generate_other_pages() {
  echo "Generating other pages..."
  for file in "$1"/notes/*.md; do
    filename=$(basename "$file")
    if [[ $filename != "README.md" ]]; then
      if [[ $filename =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
        pandoc --from markdown --to html \
          --standalone \
          --template "$2"/templates/template.html \
          --css "$2"/out/style.css \
          --metadata title="$filename" \
          --highlight-style="$2"/templates/custom.theme \
          "$file" -o "$3/posts/$(basename "$file" .md).html"
      else
        pandoc --from markdown --to html \
          --standalone \
          --template "$2"/templates/template.html \
          --css "$2"/out/style.csss \
          --metadata title="$filename" \
          --highlight-style="$2"/templates/custom.theme \
          "$file" -o "$3/$(basename "$file" .md).html"
      fi
    fi
  done
}

write_privacy_policy() {
  # write privacy.md as notes/privacy.md
  cat >"$1/notes/privacy.md" <<EOF
  # Privacy Policy
  - This site does not set or use cookies.
  - This site does not store data in the browser to be shared, sent, or sold to third-parties.
  - No personal information is, in any shape or form, shared, sent, sold or otherwise shared with third-parties.
EOF
}

write_about_page() {
  # write about.md as notes/about.md
  cat >"$1/notes/about.md" <<-EOF
  I work with Nix quite often, and share some of the stuff I learn while I do so. This website contains various notes
  on things that interested me, or things I thought was worth sharing. If you would like to contribute, or have any feedback
  you think would be useful, please feel free to reach out to me via email, available at my GitHub profile or on my website:
  https://notashelf.dev
EOF
}

generate_rss_feed() {
  echo "Generating RSS feed..."
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
 <rss version=\"2.0\">
 <channel>
 <title>$1</title>
 <link>$2</link>
 <description>$3</description>" >"$4"

  # Use jq to generate XML for each item
  jq -r '.posts[] | select(.url != null) | "<item><title>\(.title)</title><link>\(.url)</link><description></description></item>"' "$5" | while read -r item; do
    echo "$item" >>"$4"
  done

  echo "</channel>
 </rss>" >>"$4"
}

create_directory "$outdir"
create_directory "$posts_dir"
generate_json "$workingdir" "$json_file"
compile_stylesheet "$workingdir"
write_about_page "$workingdir"
write_privacy_policy "$workingdir"
generate_index_page "$workingdir" "$outdir"
generate_other_pages "$workingdir" "$workingdir" "$outdir"
generate_rss_feed "$rss_title" "$rss_link" "$rss_description" "$rss_file" "$json_file"

echo "All tasks completed successfully."
