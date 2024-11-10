#!/usr/bin/env bash
# set -euo pipefail
IFS=$'\n\t '

# This script makes symbolic links between config files and their corresponding
# destinations under $HOME. Note that existent destination files will be
# overridden.

curr_path=$(cd $(dirname $0) && pwd)

huma_char="$curr_path"/.local/share/fcitx5/table/huma-char.txt
huma_lua="$curr_path"/.local/share/nvim/lazy/hop.nvim/lua/hop/mappings/zh_huma.lua
if [ "$huma_char" -nt "$huma_lua" ]; then
  gawk -f "$curr_path"/huma2hop.gawk -- "$huma_char" > "$huma_lua"
fi

# skip .git/, .gitignore, and $curr_path/[^.]+
files=$(find "$curr_path" -type f | grep -vE "(\.git/|\.gitignore|\.nvim\.lua|$curr_path/[^.])")
for filename in $files; do
    destination="$HOME/"${filename/#*dotfiles\/}
    mkdir -p "${destination%/*}" || :
    # If the destination is not symbolically linked to the filename
    if [ ! -L "$destination" ] || [ ! "$(readlink -f "$destination")" == "$(readlink -f "$filename")" ] ; then
      ln --verbose --force --symbolic "$filename" "$destination"
    fi
done
