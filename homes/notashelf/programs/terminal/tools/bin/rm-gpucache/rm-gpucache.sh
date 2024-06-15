#!/usr/bin/env bash

cleanup_caches() {
  echo "Cleaning up caches."
  if ! find "$HOME" -type d -name "GPUCache" -exec rm -r {} +; then
    echo "Error: Failed to remove some caches." >&2
  else
    echo "Done!"
  fi
}

# List GPU caches
list_caches() {
  echo "Found caches:"
  find "$HOME" -type d -name "GPUCache"
}

case "$1" in
-r)
  cleanup_caches
  ;;
-l)
  list_caches
  ;;
*)
  echo "Usage:"
  echo 'gpucache -r : Remove all GPUCache directories found under $HOME'
  echo 'gpucache -l : List all GPUCache directories found under $HOME'
  exit 1
  ;;
esac
