#!/bin/bash

# Check if DIR is a directory (and not file, symlink, etc ...)
function is-dir {
  DIR=$1

  if [ -d "$DIR" ] && [ ! -L "$DIR" ]; then
    return 1 # true
  fi

  return 0 # false
}

# Check if DIR has a `.config` folder inside
function has-config {
  DIR=$1

  # Return false if DIR is not a directory or is a symlink
  is-dir "$DIR"
  if [ $? -eq 0 ]; then
    return 0 # false
  fi
  
  # Return false if DIR/.config is not a directory
  is-dir "$DIR/.config"
  if [ $? -eq 0 ]; then
    return 0 # false
  fi

  return 1 # true
}

# Check if script is executed from .dotfiles directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_DIR="$PWD"
if [ "$SCRIPT_DIR" != "$CURRENT_DIR" ]; then
  echo "Error: This script must be executed from the directory it is located in."
  echo "Script directory: $SCRIPT_DIR"
  echo "Current directory: $CURRENT_DIR"
  exit -1
fi

# Iterate over folders
for dir in */ ; do
  [ -L "${dir%/}" ] && continue # exclude symlinks (if there are any)

  has-config "$dir"
  if [ $? -eq 1 ]; then
    echo "$dir"
    stow -S -v -n "$dir"
  else
    echo "skip $dir"
  fi
  echo "---"
done

