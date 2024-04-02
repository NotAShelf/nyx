{
  writeShellApplication,
  pandoc,
  jaq,
  ...
}:
writeShellApplication {
  name = "generate-static-notes";
  runtimeInputs = [pandoc jaq];
  text = ''
    workingdir=${./.}
    outdir=${placeholder "out"}

    if [ ! -d "$outdir" ]; then
      mkdir "$outdir"
    fi

    # Generate index page
    pandoc --standalone \
      --from markdown --to html \
      --template "$workingdir"/template.html \
      --css "$workingdir"/style.css \
      --variable="index:true" \
      "$workingdir/notes/README.md" -o "$outdir/index.html"

    # Generate other pages
    if [ -f "$outdir"/index.html ]; then
      for file in "$workingdir"/notes/*.md; do
        if [ "$(basename "$file")" != "README.md" ]; then
          pandoc --from markdown --to html \
            --standalone --template "$workingdir"/template.html \
            --css "$workingdir"/style.css \
            "$file" -o "$outdir"/"$(basename "$file" .md)".html
        fi
      done
    fi

    # Generate JSON
    json='{"posts":['
    first=true
    for file in "$workingdir"/notes/*.md; do
      filename=$(basename "$file")
      if [ "$filename" != "README.md" ]; then
        date=$(echo "$filename" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
        if [ -n "$date" ]; then
          if [ "$first" = true ]; then
            first=false
          else
            json="$json,"
          fi
          json="$json{\"title\":\"$filename\",\"path\":\"$file\",\"date\":\"$date\"}"
        fi
      fi
    done
    json="$json]}"

    # Write JSON to file
    echo "$json" | jaq >"$outdir/posts.json"
  '';
}
