#!/usr/bin/env bash
# set -euo pipefail
IFS=$'\n\t '

# This script makes symbolic links between config files and their corresponding
# destinations under $HOME. Note that existent destination files will be
# overridden.

curr_folder=$(cd $(dirname $0) && pwd)

# Generate hop.nvim mappings for huma
huma_char="$curr_folder"/.local/share/fcitx5/table/huma-char.txt
huma_hop="$curr_folder"/.local/share/nvim/lazy/hop.nvim/lua/hop/mappings/zh_huma.lua
if [ "$huma_char" -nt "$huma_hop" ]; then
  gawk -f "$curr_folder"/huma2hop.gawk -- "$huma_char" > "$huma_hop"
fi

# skip .git/, .gitignore, and $curr_folder/[^.]+
files=$(find "$curr_folder" -type f | grep -vE "(\.git/|\.gitignore|\.nvim\.lua|\.windows|$curr_folder/[^.])")
for filename in $files; do
    destination="$HOME/"${filename/#*dotfiles\/}
    mkdir -p "${destination%/*}" || :
    # If the destination is not symbolically linked to the filename
    if [ ! -L "$destination" ] || [ ! "$(readlink -f "$destination")" == "$(readlink -f "$filename")" ] ; then
      ln --verbose --force --symbolic "$filename" "$destination"
    fi
done
