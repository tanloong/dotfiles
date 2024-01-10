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
    ln --verbose --force --symbolic "$filename" "$destination"
done
