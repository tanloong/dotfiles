#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

curr_path=$(cd $(dirname $0) && pwd)

idir="$curr_path"/.local/share/fcitx5/table
should_restart_fcitx5=0
for file in "$idir"/*.txt; do
  destination="$HOME/"${file/#*dotfiles\/}
  destination="${destination/.txt/.dict}"
  sha1sum_file="$file.sha1sum"
  file_sha1sum=$(sha1sum "$file" | awk '{print $1}')

  if [ ! -f "$destination" ] || [ ! -f "$sha1sum_file" ] || [ "$(cat "$sha1sum_file")" != "$file_sha1sum" ]; then
    libime_tabledict "$file" "$destination"
    echo "$file_sha1sum" > "$sha1sum_file"
    should_restart_fcitx5=1
    echo "[Fcitx5] Generated $destination and $sha1sum_file"
  fi
done

if [ "$should_restart_fcitx5" -eq 1 ]; then
  fcitx5-remote -e # request fcitx5 to exit
  fcitx5-remote > /dev/null # launch fcitx5
  echo "[Fcitx5] Restarted fcitx5"
fi
