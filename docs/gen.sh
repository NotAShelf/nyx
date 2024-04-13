#!/usr/bin/env bash
set -e
set -u
set -o pipefail

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

generate_posts_json() {
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
        # that is done so by the generate_jsonfeed_spec function

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
  local workingdir="$1"
  local outdir="$2"

  echo "Generating index page..."
  pandoc --from gfm --to html \
    --standalone \
    --template "$workingdir"/templates/html/page.html \
    --css /style.css \
    --variable="index:true" \
    --metadata title="$title" \
    --metadata description="$site_description" \
    "$workingdir"/notes/README.md -o "$outdir"/index.html
}

generate_404_page() {
  local workingdir="$1"
  local tmpdir="$2"
  local outdir="$3"

  echo "Generating 404 page..."
  pandoc --from gfm --to html \
    --standalone \
    --template "$workingdir"/templates/html/404.html \
    --css /style.css \
    --metadata title="404 - Page Not Found" \
    --metadata description="$site_description" \
    "$tmpdir"/404.md -o "$outdir"/404.html
}

generate_other_pages() {
  local workingdir="$1"
  local tmpdir="$2"
  local outdir="$3"

  echo "Generating other pages..."
  for file in "$workingdir"/notes/*.md; do
    filename=$(basename "$file")
    if [[ $filename != "README.md" ]]; then
      if [[ $filename =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
        # Sanitize post title by removing date from filename
        sanitized_title=$(echo "$filename" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//; s/\.md$//; s/-/ /g; s/\b\w/\u&/g')

        # Date in filename imples a blogpost
        # convert it to markdown and place it in the posts directory
        # since this is a post, it can contain a table of contents
        echo "Converting $filename..."
        pandoc --from gfm --to html \
          --standalone \
          --template "$workingdir"/templates/html/page.html \
          --css /style.css \
          --metadata title="Posts - $sanitized_title" \
          --metadata description="$site_description" \
          --table-of-contents \
          --highlight-style="$workingdir"/templates/pandoc/custom.theme \
          "$file" -o "$outdir"/posts/"$(basename "$file" .md)".html
      else
        if [[ $filename != "*-md" ]]; then
          echo "Converting $filename..."
          # No date in filename, means this is a standalone page
          # convert it to html and place it in the pages directory
          pandoc --from gfm --to html \
            --standalone \
            --template "$workingdir"/templates/html/page.html \
            --css /style.css \
            --metadata title="$filename" \
            --metadata description="$site_description" \
            "$file" -o "$outdir"/pages/"$(basename "$file" .md)".html
        fi
      fi
    fi
  done

  for file in "$tmpdir"/*.md; do
    filename=$(basename "$file")
    if [[ $filename != "404.md" ]]; then
      pandoc --from gfm --to html \
        --standalone \
        --template "$workingdir"/templates/html/page.html \
        --css /style.css \
        --metadata title="$filename" \
        --metadata description="$site_description" \
        --highlight-style="$workingdir"/templates/pandoc/custom.theme \
        "$file" -o "$outdir"/pages/"$(basename "$file" .md)".html
    fi
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
[on my website](https://notashelf.dev).
EOF
}

write_404_page() {
  # write 404.md as notes/404.md
  cat >"$1/404.md" <<-EOF
  # 404 - Page Not Found

  Sorry, the page you were looking for does not exist.
EOF
}

cleanup() {
  echo "Cleaning up..."
  rm -rf "$tmpdir"
}

trap cleanup EXIT

# Create directories
create_directory "$outdir"
create_directory "$posts_dir"
create_directory "$pages_dir"

# Compile stylesheet
compile_stylesheet "$workingdir" "templates/scss/main.scss"

# Write markdown pages inside a tempdir
write_about_page "$tmpdir"
write_privacy_policy "$tmpdir"
write_404_page "$tmpdir"

# Generate HTML pages from available markdown templates
generate_index_page "$workingdir" "$outdir"
generate_404_page "$workingdir" "$tmpdir" "$outdir"
generate_other_pages "$workingdir" "$tmpdir" "$outdir"

# Post data
generate_posts_json "$workingdir" "$json_file"

# Cleanup
cleanup

echo "All tasks completed successfully."
