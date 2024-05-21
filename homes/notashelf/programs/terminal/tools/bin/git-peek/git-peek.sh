#!/usr/bin/env bash
#
# Function to print usage information
usage() {
  echo "git-peek - Quickly open a git repository in \$EDITOR

Usage: git peek [options...] <clone url>

Options:
    -h, --help            Print this help message
    -e, --editor <name>   Open repo in <name> instead of \$EDITOR
    -d, --depth <num>     Only clone <num> commits, or entire tree if 0 (default: 1)
    -k, --keep            Don't delete the clone after exiting
                          (implied if existing directory is passed)
    -b, --branch <ref>    Clone <ref> instead of the default branch
    -o, --dest <path>     Path to clone repo into
    -s, --shell           Open a new shell in the clone instead of \$EDITOR

Examples:
    git-peek https://github.com/torvalds/linux
    git-peek -s -b nixpkgs-unstable https://github.com/NixOS/nixpkgs"
}

_clean() {
  if [ -z "$_flag_keep" ]; then
    dirs -c
    echo "Cleaning up..."
    rm -rf "$clone_dir"
  fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    usage
    exit 0
    ;;
  -e | --editor)
    shift
    EDITOR=$1
    ;;
  -d | --depth)
    shift
    depth_arg="--depth=$1"
    ;;
  -k | --keep)
    _flag_keep=true
    ;;
  -b | --branch)
    shift
    branch_arg="--branch=$1"
    ;;
  -o | --dest)
    shift
    clone_dir=$1
    if [ -e "$clone_dir" ]; then
      echo "Path '$clone_dir' already exists."
      exit 1
    fi
    ;;
  -s | --shell)
    _flag_shell=true
    ;;
  *)
    break
    ;;
  esac
  shift
done

# If no arguments are passed, print usage
if [ $# -eq 0 ] || [ -z "$1" ]; then
  usage
  exit 1
fi

# Set default values
depth_arg="--depth=1"
clone_dir=$(mktemp -d /tmp/git-peek.XXXXXX)

# Main procedure
echo "Cloning $1 into $clone_dir..."
if ! git clone "$1" "$clone_dir" "$branch_arg" "$depth_arg"; then
  echo "Cloning was not successful."
  _clean
  exit 1
fi

cd "$clone_dir" || exit 1
if [ -z "$_flag_shell" ]; then
  echo "Opening with $EDITOR..."
  "$EDITOR" "$clone_dir"
else
  echo "Opening a new shell at $clone_dir..."
  if [ -z "$_flag_keep" ]; then
    echo "Will clean up after the shell exits."
  fi
  "$SHELL"
fi
cd - >/dev/null || exit 1
_clean
