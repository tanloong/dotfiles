#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

curr_path=$(cd $(dirname $0) && pwd)

table_dir="$curr_path"/.local/share/fcitx5/table
conf_dir="$curr_path"/.local/share/fcitx5/inputmethod
should_restart=0

# Check for table_dir
for file in "$table_dir"/*.txt; do
  destination="$HOME/"${file/#*dotfiles\/}
  destination="${destination/.txt/.dict}"
  sha1sum_file="$file.sha1sum"
  file_sha1sum=$(sha1sum "$file" | awk '{print $1}')

  if [ ! -f "$destination" ] || [ ! -f "$sha1sum_file" ] || [ "$(cat "$sha1sum_file")" != "$file_sha1sum" ]; then
    libime_tabledict "$file" "$destination"
    echo "$file_sha1sum" > "$sha1sum_file"
    should_restart=1
    echo "[Fcitx5] Generated $destination and $sha1sum_file"
  fi
done

# Check for conf_dir
for file in "$conf_dir"/*.conf; do
  sha1sum_file="$file.sha1sum"
  file_sha1sum=$(sha1sum "$file" | awk '{print $1}')

  if [ ! -f "$sha1sum_file" ] || [ "$(cat "$sha1sum_file")" != "$file_sha1sum" ]; then
    echo "$file_sha1sum" > "$sha1sum_file"
    should_restart=1
  fi
done

# Restart or reload fcitx5
if [ "$should_restart" -eq 1 ]; then
  fcitx5-remote -e # request fcitx5 to exit
  fcitx5-remote > /dev/null # launch fcitx5
  echo "[Fcitx5] Restarted"
fi
