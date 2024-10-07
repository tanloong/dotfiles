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

case "$1" in
    "" ) ;;
    *[!0-9]* ) 
      echo "$1 is not a number!"
      printhelp ;; 
    * ) THRESHOLD=$1 ;;
esac

if [ $# -eq 2 ] && [ -n "$2" ]
then
    if [ -d "$2" ]
    then
        UNDO_PATH=$2
    else
        echo "$2 is not a directory!"
        printhelp
    fi
fi

find "$UNDO_PATH" -mtime "+$THRESHOLD" -print -delete | tee "$REMOVE_LOG"

echo "done, a log has been created at $REMOVE_LOG"
