#!/usr/bin/env bash
# set -euo pipefail
IFS=$'\n\t '

# This script makes symbolic links between config files and their corresponding
# destinations. Note that it will override existing destination files.

curr_path=$(cd $(dirname $0) && pwd)

# skip .git/, .gitignore, and $curr_path/[^.]+
files=$(find "$curr_path" -type f | grep -vE "(\.git/|\.gitignore|$curr_path/[^.])")
for filename in $files; do
    destination="$HOME/"${filename/#*dotfiles\/}
    mkdir -p "${destination%/*}" || :
    if [ ! -L "$destination" ]; then
      ln --verbose --force --symbolic "$filename" "$destination"
    fi
done

# make custom table for fcitx5
idir="$curr_path"/.local/share/fcitx5/table
for file in "$idir"/*.txt; do
  destination="$HOME/"${file/#*dotfiles\/}
  destination="${destination/.txt/.dict}"
  if [ ! -f "$destination" ] || [ "$destination" -ot "$file" ]; then
    libime_tabledict "$file" "$destination"
    echo "[Fcitx5] Generated $destination"
  fi
done
