#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# cleans unused vim undofile
# This script assumes that you store undofile in a seperated directory

UNDO_PATH="$HOME/.local/state/nvim/undo/"
THRESHOLD="30" # in day, if the last modified time is beyond this value, the undofile will be deleted
REMOVE_LOG="/tmp/undoclean-log"

E_WRONGARGS=65
printhelp() {
  echo "Usage: $(basename "$0") [THRESHOLD] [UNDO_PATH]"
    exit $E_WRONGARGS
}

if [ $# -gt 2 ]; then
  printhelp
fi

if [ $# -ge 1 ]; then
  if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "$1 is not an integer!"
    printhelp
  else
    THRESHOLD=$1
  fi
fi

if [ $# -eq 2 ] && [ -n "$2" ]; then
    if [ -d "$2" ]; then
        UNDO_PATH="$2"
    else
        echo "$2 is not a directory!"
        printhelp
    fi
fi

echo "THRESHOLD=$THRESHOLD"
echo "UNDO_PATH=$UNDO_PATH"

find "$UNDO_PATH" -mtime "+$THRESHOLD" -print -delete | tee "$REMOVE_LOG"

echo "done, a log has been created at $REMOVE_LOG"
