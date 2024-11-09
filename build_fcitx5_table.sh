#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

curr_path=$(cd $(dirname $0) && pwd)

idir="$curr_path"/.local/share/fcitx5/table
should_restart_fcitx5=0
for file in "$idir"/*.txt; do
  destination="$HOME/"${file/#*dotfiles\/}
  destination="${destination/.txt/.dict}"
  if [ ! -f "$destination" ] || [ "$destination" -ot "$file" ]; then
    libime_tabledict "$file" "$destination"
    should_restart_fcitx5=1
    echo "[Fcitx5] Generated $destination"
  fi
done
if [ "$should_restart_fcitx5" -eq 1 ]; then
  fcitx5-remote -e # request fcitx5 to exit
  fcitx5-remote > /dev/null # launch fcitx5
  echo "[Fcitx5] Restarted fcitx5"
fi
