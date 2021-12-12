#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t '

# This script makes symbolic links between cofigure files and their
# corresponding destination files. Note that it will remove existing
# destination files.

cur_path=$(cd $(dirname $0) && pwd)

# 跳过 .git 文件夹，.gitignore，$cur_path/ 下非点号开头的文件
files=$(find "$cur_path" -type f | grep -vE "(\.git\/|\.gitignore|$cur_path/[^\.])")
for filename in $files; do
    destination="$HOME/"${filename/#*dotfiles\/}
    mkdir -p ${destination%/*} || :
    ln --verbose --force --symbolic "$filename" "$destination"
done
