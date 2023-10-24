#!/usr/bin/env bash

mkdir -p mods/

# Loop through each subdirectory in the current directory
for subdir in */; do
  # Find the most recently accessed file with a .tmod extension in the subdirectory
  latest_file=$(find "$subdir" -name "*.tmod" -type f -printf "%T@ %p\n" | sort -n | tail -1 | awk '{print $2}')
  # Copy the latest file found (if any) to the mods/ directory
  if [[ -n $latest_file ]]; then
    cp "$latest_file" "mods/"
    echo "Copied $latest_file to mods/"
  else
    echo "No .tmod files found in $subdir"
  fi
done

# Zip up the mods/ directory
zip -r mods.zip mods/
echo -en "Zipped up mods/ directory to mods.zip"
