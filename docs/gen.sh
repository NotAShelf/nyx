#!/usr/bin/env bash
set -e

# Site Meta
title="NotAShelf/nyx"
site_url="https://nyx.notashelf.dev"
site_description="NotAShelf's notes on various topics"

# Directories
tmpdir="$(mktemp -d)"
workingdir="$(pwd)"
outdir="$workingdir"/out
posts_dir="$outdir/posts"
pages_dir="$outdir/pages"

# A list of posts
json_file="$posts_dir/posts.json"

# Feed files
rss_file="$outdir/feed.xml"

create_directory() {
  if [ ! -d "$1" ]; then
    echo "Creating directory: $1"
    mkdir -p "$1"
  fi
}

compile_stylesheet() {
  echo "Compiling stylesheet..."
  sassc --style=compressed "$1"/"$2" "$1"/out/style.css
}

compile_scripts() {
  # Copy javascript files to the page root
  # TODO: in the future, we may want to use typescript
  # which we then compile into javascript
  cp -r "$1"/templates/js "$2"

}

generate_json() {
  echo "Generating JSON..."
  json='{"posts":['
  first=true
  for file in "$1"/notes/*.md; do
    filename=$(basename "$file")
    if [[ $filename != "README.md" ]]; then
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

        # JSON object with data we may want to use like a json feed file
        # this doesn't, however, actually follow jsonfeed spec
        # TODO: follow jsonfeed spec
        # https://www.jsonfeed.org/
        json_object=$(jq -n \
          --arg name "$filename" \
          --arg url "$site_url/posts/$(basename "$file" .md).html" \
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
  pandoc --from gfm --to html \
    --standalone \
    --template "$1"/templates/template.html \
    --css /style.css \
    --variable="index:true" \
    --metadata title="$title" \
    --metadata description="$site_description" \
    "$1/notes/README.md" -o "$2/index.html"
}

generate_other_pages() {
  echo "Generating other pages..."
  for file in "$1"/notes/*.md; do
    filename=$(basename "$file")
    if [[ $filename != "README.md" ]]; then
      if [[ $filename =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
        # Date in filename imples a blogpost
        # convert it to markdown and place it in the posts directory
        # since this is a post, it can contain a table of contents
        echo "Converting $filename..."
        pandoc --from gfm --to html \
          --standalone \
          --template "$2"/templates/template.html \
          --css /style.css \
          --metadata title="$filename" \
          --metadata description="$site_description" \
          --table-of-contents \
          --highlight-style="$2"/templates/custom.theme \
          "$file" -o "$3/posts/$(basename "$file" .md).html"
      else
        if [[ $filename != "*-md" ]]; then
          echo "Converting $filename..."
          # No date in filename, means this is a standalone page
          # convert it to html and place it in the pages directory
          pandoc --from gfm --to html \
            --standalone \
            --template "$2"/templates/template.html \
            --css /style.css \
            --metadata title="$filename" \
            --metadata description="$site_description" \
            --highlight-style="$2"/templates/custom.theme \
            "$file" -o "$3/pages/$(basename "$file" .md).html"
        fi
      fi
    fi
  done
  for file in "$4"/*.md; do
    filename=$(basename "$file")
    pandoc --from gfm --to html \
      --standalone \
      --template "$2"/templates/template.html \
      --css /style.css \
      --metadata title="$filename" \
      --metadata description="$site_description" \
      --highlight-style="$2"/templates/custom.theme \
      "$file" -o "$3/pages/$(basename "$file" .md).html"
  done
}

write_privacy_policy() {
  # write privacy.md as notes/privacy.md
  cat >"$1/privacy.md" <<EOF
# Privacy Policy

This site is hosted on Github Pages, their privacy policies apply at any given time.

The author of this site:
- does not set or use cookies.
- does not store data in the browser to be shared, sent, or sold to third-parties.
- does not collect, sell, send or otherwise share your private information with any third parties.

Effective as of April 5th, 2024.
EOF
}

write_about_page() {
  # write about.md as notes/about.md
  cat >"$1/about.md" <<-EOF
# About

I work with Nix quite often, and share some of the stuff I learn while I do so. This website contains various notes
on things that interested me, or things I thought was worth sharing. If you would like to contribute, or have any feedback
you think would be useful, please feel free to reach out to me via email, available at my GitHub profile or
[on my website](https://notashelf.dev)
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

cleanup() {
  echo "Cleaning up..."
  rm -rf "$tmpdir"
}

create_directory "$outdir"
create_directory "$posts_dir"
create_directory "$pages_dir"
generate_json "$workingdir" "$json_file"
compile_stylesheet "$workingdir" "templates/scss/main.scss"
compile_scripts "$workingdir" "$outdir"
write_about_page "$tmpdir"
write_privacy_policy "$tmpdir"
generate_index_page "$workingdir" "$outdir"
generate_other_pages "$workingdir" "$workingdir" "$outdir" "$tmpdir"
generate_rss_feed "$title" "$site_url" "$site_description" "$rss_file" "$json_file"
cleanup

echo "All tasks completed successfully."
