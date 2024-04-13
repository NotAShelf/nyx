#!/usr/bin/env bash

# find all .direnv directories
direnv_dirs=$(fd -I -a --hidden --type directory --glob '.direnv')

# check if any directories were found
if [ -z "$direnv_dirs" ]; then
  echo "No .direnv directories found."
  exit 0
fi

# print report
echo "The following .direnv directories will be deleted:"
echo "$direnv_dirs"

# confirm deletion
read -p "Are you sure you want to delete these directories? (y/n) " -n 1 -r

# move to a new line
echo -en "\n"

if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Delete directories
  echo "Deleting directories..."
  for dir in $direnv_dirs; do
    rm -rf "$dir"
  done
  echo "Directories deleted."
else
  echo "Operation cancelled."
fi
