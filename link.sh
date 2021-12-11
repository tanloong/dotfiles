#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t '

cur_path=$(cd $(dirname $0) && pwd)

#############
### FUNCTIONS
#############

link() {
    if [ ! -L "$2" ]; then
        rm -f "$2" >/dev/null 2>&1 || :
        sudo ln -s "$1" "$2"
        echo "linked $2"
    fi
}

#############
### MAIN
#############
# 跳过 .git 文件夹，.gitignore，$cur_path/ 下非点号开头的文件
files=$(find "$cur_path" -type f | grep -vE "(\.git\/|\.gitignore|$cur_path/[^\.])")
for filename in $files; do
    target="$HOME/"${filename/#*dotfiles\/}
    mkdir -p ${target%/*} || :
    link "$filename" "$target"
done
